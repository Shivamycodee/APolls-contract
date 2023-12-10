const {ethers} = require("hardhat")
const {AA_VERIFIER_ADDRESS} = require('./data')

async function main (){

     const vote = await ethers.deployContract("Vote", [
       "Whom would you choose as your 'Earth President'?",
       ["Elon Musk", "MR BEAN", "OSHO", "ARTIFICIAL INTELLIGENCE"],
       AA_VERIFIER_ADDRESS,
     ]);

  console.log("vote : ", vote.target);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
