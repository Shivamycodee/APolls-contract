// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./interfaces/IAnonAadhaarVerifier.sol";


contract Vote {
    // Structure to hold proposal information
    struct Proposal {
        string description;
        uint256 voteCount;
    }

    string public votingQuestion;
    address public anonAadhaarVerifierAddr;
    address public owner;

    uint public votingStartTime;
    uint public votingTimeRange;
    bool public canPeopleVote;

    event Voted(string description, uint _startVotingTime, uint _endVotingTime);

    // List of proposals
    Proposal[] public proposals;

    mapping(address => bool) public hasVoted;

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Constructor to initialize proposals
    constructor(string memory _votingQuestion, string[] memory proposalDescriptions, address _verifierAddr) {
        owner = msg.sender;
        anonAadhaarVerifierAddr = _verifierAddr;
        votingQuestion = _votingQuestion;
        for (uint256 i = 0; i < proposalDescriptions.length; i++) {
            proposals.push(Proposal(proposalDescriptions[i], 0));
        }
    }

    function startVoting(uint _votingTimeRange) public onlyOwner{
        canPeopleVote = true;
        votingStartTime = block.timestamp;
        votingTimeRange = _votingTimeRange;
    }

    function setVotingTimeRange(uint _votingTimeRange) public onlyOwner{
        votingTimeRange = _votingTimeRange;
    }

    function changeVotingQuestion(string memory _votingQuestion) public onlyOwner{
        votingQuestion = _votingQuestion;
    }

    function changeProposalDescription(string[] memory _newProposalDescriptions) public onlyOwner{
        for (uint256 i = 0; i < _newProposalDescriptions.length; i++) {
            proposals[i].description = _newProposalDescriptions[i];
            proposals[i].voteCount = 0;
        }
    }

    function verify(uint256[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public view returns (bool) {
        return IAnonAadhaarVerifier(anonAadhaarVerifierAddr).verifyProof(_pA, _pB, _pC, _pubSignals);
    }
    
    // Function to vote for a proposal
    function voteForProposal(uint256 proposalIndex, uint256[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public {

        require(canPeopleVote, "Voting is not allowed");
        require(block.timestamp >= votingStartTime, "Voting has not started yet");
        require(block.timestamp <= votingStartTime + votingTimeRange, "Voting has ended");

        require(proposalIndex < proposals.length, "Invalid proposal index");
        require(!hasVoted[msg.sender], "You have already voted");
        require(verify(_pA, _pB, _pC, _pubSignals), "Your idendity proof is not valid");

        proposals[proposalIndex].voteCount++;
        hasVoted[msg.sender] = true;
        emit Voted(proposals[proposalIndex].description,votingStartTime,votingStartTime + votingTimeRange);
    }

    // Function to get the total number of proposals
    function getProposalCount() public view returns (uint256) {
        return proposals.length;
    }

    // Function to get proposal information by index
    function getProposal(uint256 proposalIndex) public view returns (string memory, uint256) {
        require(proposalIndex < proposals.length, "Invalid proposal index");

        Proposal memory proposal = proposals[proposalIndex];
        return (proposal.description, proposal.voteCount);
    }

    // Function to get the total number of votes across all proposals
    function getTotalVotes() public view returns (uint256) {
        uint256 totalVotes = 0;
        for (uint256 i = 0; i < proposals.length; i++) {
            totalVotes += proposals[i].voteCount;
        }
        return totalVotes;
    }    

    // Function to check if a user has already voted
    function checkVoted(address _addr) public view returns (bool) {
        return hasVoted[_addr];
    } 

    function getAllProposals() public view returns (Proposal[] memory) {
        return proposals;
    }

}