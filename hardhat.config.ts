import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";
require("dotenv").config();
const { MAINNET_RPC, GOERLI_RPC, ETHERSCAN_API, PRIVATE_KEY1 } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    hardhat: {
      forking: {
        url: GOERLI_RPC!,
      },
    },
    goerli: {
      url: GOERLI_RPC,
      accounts: [PRIVATE_KEY1!],
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API,
  },
};

export default config;
