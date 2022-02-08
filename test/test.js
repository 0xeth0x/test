const { expect } = require("chai");
const { ethers } = require("hardhat");

const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
const big = num => ethers.BigNumber.from(num);

describe("ContractA", function () {
  it("should set ContractB", async function () {
    const [owner, contractB] = await ethers.getSigners();
    const ContractA = await ethers.getContractFactory("ContractA");
    const contractA = await ContractA.deploy();
    
    expect(await contractA.contractB()).to.be.equal(ZERO_ADDRESS);

    await contractA.setContractB(contractB.address);

    expect(await contractA.contractB()).to.be.equal(contractB.address);
  });

  it("should deposit tokens to ContractA and record in ContractB", async function () {
    const [owner] = await ethers.getSigners();
    const ContractA = await ethers.getContractFactory("ContractA");
    const contractA = await ContractA.deploy();

    const ContractB = await ethers.getContractFactory("ContractB");
    const contractB = await ContractB.deploy();

    const MockToken = await ethers.getContractFactory("MockToken");
    const mockToken = await MockToken.deploy();
    
    await contractA.setContractB(contractB.address);
    await contractB.setContractA(contractA.address);

    const amount = big(1000).mul(big(10).pow(big(18)));
    await mockToken.approve(
      contractA.address,
      amount
    );

    await contractA.deposit(mockToken.address, amount);

    expect(await contractB.tokenToUserDeposit(mockToken.address, owner.address))
      .to.be.equal(amount);
  });

  it("should record tokens in ContractB by admin", async function () {
    const [owner, user] = await ethers.getSigners();
  
    const ContractB = await ethers.getContractFactory("ContractB");
    const contractB = await ContractB.deploy();

    const MockToken = await ethers.getContractFactory("MockToken");
    const mockToken = await MockToken.deploy();
    

    const amount = big(1000).mul(big(10).pow(big(18)));  

    await contractB.recordDeposit(
      user.address,
      mockToken.address, 
      amount
    );

    expect(await contractB.tokenToUserDeposit(mockToken.address, user.address))
      .to.be.equal(amount);
  });

});
