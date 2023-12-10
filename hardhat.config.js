// hardhat.config.ts
require("@nomicfoundation/hardhat-toolbox");
require("hardhat-dependency-compiler");


const ANON_AADHAAR_RPVKEY =
  "";

const URL =
  "https://eth-goerli.g.alchemy.com/v2/wzkz501HP50QhfPIWRy8-9gtvF4BrAR0";

module.exports = {
  solidity: "0.8.19",
  dependencyCompiler: {
    paths: ["anon-aadhaar-contracts/contracts/Verifier.sol"],
  },
  networks: {
    goerli: {
      url: URL,
      // gasPrice: 150_000_000_000,
      accounts: [ANON_AADHAAR_RPVKEY],
    },
  },
  etherscan: {
    apiKey: "5YGG7GXBGQFEAYR6ZYDBYQJ8VWIQY1WGER",
  },
};
