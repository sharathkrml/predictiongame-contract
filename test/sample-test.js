const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PredictionGame", () => {
  let GameContract;
  let GameTokenContract;
  let owner;
  let accounts;
  beforeEach(async () => {
    const GameTokenFactory = await ethers.getContractFactory("GameToken");
    GameTokenContract = await GameTokenFactory.deploy();
    await GameTokenContract.deployed();

    const GameFactory = await ethers.getContractFactory("PredictionGame");
    GameContract = await GameFactory.deploy(GameTokenContract.address);
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
        await GameTokenContract.connect(accounts[i]).mint();
        console.log("Just minted", ethers.utils.formatEther(await GameTokenContract.balanceOf(accounts[i].address)));
        let b = await GameTokenContract.connect(accounts[i]).approve(GameContract.address, ethers.utils.parseEther("1"))
        let res = await GameTokenContract.allowance(accounts[i].address, GameContract.address);
        let a = await GameContract.connect(accounts[i]).predict(i + 1);
      }
      // let count = await GameContract.count();
      // for (let i = 0; i < count; i++) {
      //   console.log(await GameContract.predictions(i));
      // }
      console.log("ContractBalance before", await GameTokenContract.balanceOf(GameContract.address));

      let res = await GameContract.getResult(5);
      for (let i = 0; i < 10; i++) {
        console.log(ethers.utils.formatEther(await GameTokenContract.balanceOf(accounts[i].address)));
      }
      console.log("ContractBalance after", await GameTokenContract.balanceOf(GameContract.address));
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
      let arr = [3, 4, 5, 4, 3, 5, 4, 3, 2, 1]
      for (let i = 0; i < 9; i++) {
        await GameTokenContract.connect(accounts[i]).mint();
        let b = await GameTokenContract.connect(accounts[i]).approve(GameContract.address, ethers.utils.parseEther("1"))
        let res = await GameTokenContract.allowance(accounts[i].address, GameContract.address);
        let a = await GameContract.connect(accounts[i]).predict(i + 1);
      }
      // let count = await GameContract.count();
      // for (let i = 0; i < count; i++) {
      //   console.log(await GameContract.predictions(i));
      // }
      console.log("before", await GameTokenContract.balanceOf(GameContract.address));

      let res = await GameContract.getResult(5);
      let a = await res.wait()
      console.log("after", await GameTokenContract.balanceOf(GameContract.address));
      // let count = await GameContract.count();
      // for (let i = 0; i < count; i++) {
      //   console.log(await GameContract.predictions(i));
      // }
    })


    it("more than 10", async () => {
      let arr = [3, 4, 5, 4, 3, 5, 4, 3, 2, 1, 1]
      for (let i = 0; i < 11; i++) {
        await GameTokenContract.connect(accounts[i]).mint();
        let b = await GameTokenContract.connect(accounts[i]).approve(GameContract.address, ethers.utils.parseEther("1"))
        let res = await GameTokenContract.allowance(accounts[i].address, GameContract.address);
        let a = await GameContract.connect(accounts[i]).predict(i + 1);
      }
      // let count = await GameContract.count();
      // for (let i = 0; i < count; i++) {
      //   console.log(await GameContract.predictions(i));
      // }
      console.log("before", await GameTokenContract.balanceOf(GameContract.address));

      let res = await GameContract.getResult(5);
      let a = await res.wait()
      console.log("after", await GameTokenContract.balanceOf(GameContract.address));
      // let count = await GameContract.count();
      // for (let i = 0; i < count; i++) {
      //   console.log(await GameContract.predictions(i));
      // }
    })
  })
});
