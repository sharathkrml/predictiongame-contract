
const hre = require("hardhat");

async function main() {
  const GameTokenFactory = await hre.ethers.getContractFactory("GameToken");
  const TokenContract = await GameTokenFactory.deploy();
  await TokenContract.deployed();
  const PredictionGameFactory = await hre.ethers.getContractFactory("PredictionGame")
  /**
     * Network: Kovan
     * Aggregator: ETH/USD
     * Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
     */
  const GameContract = await PredictionGameFactory.deploy(TokenContract.address, 0x9326BFA02ADD2366b30bacB125260Af641031331, 1653497310, 7200)
  await GameContract.deployed()
  console.log("Game deployed to:", GameContract.address);
  console.log("Token deployed to:", GameContract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
