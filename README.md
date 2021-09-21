# PayMagic Smart Contracts

This repo will contain all the smart contracts, test files, and deploy scripts for our entry into ETHOnline, PayMagic. Currently, the deploy script is configured to deploy to the Kovan testnet.

An .env file with `INFURA_KOVAN_KEY` equal to your Kovan RPC endpoint and `KOVAN_PRIVATE_KEY` equal to your private key is required to deploy to Kovan.

From there, you can deploy to Kovan with:
`npx hardhat run scripts/deploy.js --network kovan `
