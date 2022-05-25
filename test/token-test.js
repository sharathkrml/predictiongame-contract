const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("GameToken", () => {
    let GameTokenContract;
    let owner;
    let accounts;
    beforeEach(async () => {
        const GameTokenFactory = await ethers.getContractFactory("GameToken");
        GameTokenContract = await GameTokenFactory.deploy();
        await GameTokenContract.deployed();
        [owner, ...accounts] = await ethers.getSigners();
})

describe('check mint', async () => {
    it("mint", async () => {
        await GameTokenContract.mint();
        await GameTokenContract.mint({
            value: ethers.utils.parseEther("0.01")
        });
        let bal = await GameTokenContract.balanceOf(owner.address);
        console.log(bal)
    })

})
});
