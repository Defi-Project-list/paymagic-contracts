const { expect } = require("chai");
const { ethers } = require("hardhat");
const amount = ethers.utils.parseEther("1");

describe("disperseEther", function () {
  let addr1, addr2, addr3, disperse;

  beforeEach(async () => {
    const Disperse = await ethers.getContractFactory("Disperse");
    disperse = await Disperse.deploy();
    await disperse.deployed();

    [addr1, addr2, addr3] = await ethers.getSigners();
  });

  it("Should send 5 Ether to Address 2 and Address 3", async function () {
    const addr2Balance = await ethers.provider.getBalance(addr2.address);
    const addr3Balance = await ethers.provider.getBalance(addr3.address);
    const overrides = {
      value: ethers.utils.parseEther("10.0"),
    };
    const tx = await disperse.disperseEther(
      [addr2.address, addr3.address],
      [ethers.utils.parseEther("5.0"), ethers.utils.parseEther("5.0")],
      overrides
    );

    await tx.wait();

    const addr2BalanceNew = await ethers.provider.getBalance(addr2.address);
    expect(5 + parseInt(ethers.utils.formatEther(addr2Balance))).equal(
      parseInt(ethers.utils.formatEther(addr2BalanceNew))
    );
    const addr3BalanceNew = await ethers.provider.getBalance(addr3.address);
    expect(5 + parseInt(ethers.utils.formatEther(addr3Balance))).equal(
      parseInt(ethers.utils.formatEther(addr3BalanceNew))
    );
  });
});
