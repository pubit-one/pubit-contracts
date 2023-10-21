require("@nomicfoundation/hardhat-toolbox");
require("@openzeppelin/hardhat-upgrades");
require("dotenv").config();
require("@openzeppelin/hardhat-upgrades");
require("solidity-coverage");
require("@nomicfoundation/hardhat-chai-matchers");
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      evmVersion: "london",
      viaIR: true && false,
      outputSelection: { "*": { "*": ["storageLayout"] } },
    },
  },
  networks: {
    scroll: {
      url: process.env.SCROLL_TESTNET_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
    },
    localhost: { url: "http://127.0.0.1:8545" },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },

  mocha: { timeout: 40000000 },
  defaultNetwork: "scroll",
  dependencyCompiler: {
    paths: ["@scroll-tech/contracts/L2/predeploys/IL1GasPriceOracle.sol"],
  },
};
