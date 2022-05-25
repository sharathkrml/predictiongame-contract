const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PredictionGame", () => {
  let GameContract;
  let owner;
  let accounts;
  beforeEach(async () => {
    const GameFactory = await ethers.getContractFactory("PredictionGame");
    GameContract = await GameFactory.deploy();
    await GameContract.deployed();
    [owner, ...accounts] = await ethers.getSigners();
  })
  describe('check prediction', async () => {
    it("new prediction", async () => {
      for (let i = 0; i < 10; i++) {
        let a = await GameContract.connect(accounts[i]).predict(i+1);
        console.log(await a.wait());
      }
      let count = await GameContract.count();
      for (let i = 0; i < count; i++) {
        console.log(await GameContract.predictions(i));
      }
    })
  })
});
