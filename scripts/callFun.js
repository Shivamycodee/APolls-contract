const {ethers} = require("hardhat");
const {VOTE_CONTRACT_ADDRESS} = require("./data")


async function main(){

  const [deployer] = await ethers.getSigners();

    const VoteContract = await ethers.getContractAt(
      "Vote",
      VOTE_CONTRACT_ADDRESS
    );

    const time = 3600 * 20;

    const tx = await VoteContract.connect(deployer).startVoting(time);
    console.log("tx : ", tx.hash);

    // const tx = await VoteContract.connect(deployer).checkVoted(deployer.address);
    // console.log("tx : ", tx);

}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});