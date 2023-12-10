const { ethers } = require("hardhat");
const { APP_ID, VERIFIER_ADDRESS } = require("./data");

async function main() {

  // Setup you appId in the smart contract
  const appId = BigInt(APP_ID).toString();

  const anonAadhaarVerifier = await ethers.deployContract(
    "AnonAadhaarVerifier",
    [VERIFIER_ADDRESS, appId]
  );

  console.log("anonAadhaarVerifier address: ", anonAadhaarVerifier.target);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});