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
  // describe('check prediction', async () => {
  //   it("new prediction", async () => {
  //     for (let i = 0; i < 10; i++) {
  //       let a = await GameContract.connect(accounts[i]).predict(i+1);
  //       console.log(await a.wait());
  //     }
  //     let count = await GameContract.count();
  //     for (let i = 0; i < count; i++) {
  //       console.log(await GameContract.predictions(i));
  //     }
  //   })
  // })

  describe('check getResult', async () => {
    it("getResult", async () => {
      for (let i = 0; i < 10; i++) {
        let a = await GameContract.connect(accounts[i]).predict(i + 1);
      }
      // let count = await GameContract.count();
      // for (let i = 0; i < count; i++) {
      //   console.log(await GameContract.predictions(i));
      // }
      let res = await GameContract.getResult(5);
      let a = await res.wait()
      for (let b in a.events[0].args[0]) {
        console.log(a.events[0].args[0][b]);
      }
      // let count = await GameContract.count();
      // for (let i = 0; i < count; i++) {
      //   console.log(await GameContract.predictions(i));
      // }
    })
    it("Check some difficult", async () => {
      let arr = [3,4,5,4,3,5,4,3,2,1]
      for (let i = 0; i < 10; i++) {
        let a = await GameContract.connect(accounts[i]).predict(arr[i]);
      }
      // let count = await GameContract.count();
      // for (let i = 0; i < count; i++) {
      //   console.log(await GameContract.predictions(i));
      // }
      let res = await GameContract.getResult(5);
      let a = await res.wait()
      for (let b in a.events[0].args[0]) {
        console.log(a.events[0].args[0][b]);
      }
      // let count = await GameContract.count();
      // for (let i = 0; i < count; i++) {
      //   console.log(await GameContract.predictions(i));
      // }
    })
  })
});
