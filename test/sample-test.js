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

describe("disperseToken", function () {
  let addr1, addr2, addr3, disperse, testERC20;

  beforeEach(async () => {
    const Disperse = await ethers.getContractFactory("Disperse");
    disperse = await Disperse.deploy();
    await disperse.deployed();

    const TestERC20 = await ethers.getContractFactory("TestERC20");
    testERC20 = await TestERC20.deploy("PayMagic", "PYMG", 1000);
    await testERC20.deployed();

    [addr1, addr2, addr3] = await ethers.getSigners();
  });

  it("Should allow Address 1 to send 500 PYMG tokens to Address 2 and 500 PYMG tokens to Address 3", async function () {
    const addr1Balance = await testERC20.balanceOf(addr1.address);
    expect(addr1Balance).equal(1000);

    const addr2Balance = await testERC20.balanceOf(addr2.address);
    expect(addr2Balance).equal(0);

    const addr3Balance = await testERC20.balanceOf(addr3.address);
    expect(addr3Balance).equal(0);

    console.log(testERC20.address);
    // await testERC20.approve(addr1.address, 1100);
    // const allowance = await testERC20.allowance(addr1.address, addr1.address);

    await testERC20.approve(disperse.address, 1000);
    // await testERC20.approve(addr3.address, 500);

    await testERC20.allowance(addr1.address, addr2.address);
    // await testERC20.allowance(addr3.address, addr1.address);

    const tx = await disperse.disperseToken(
      testERC20.address,
      [addr2.address, addr3.address],
      [500, 500]
    );

    await tx.wait();

    const addr2BalanceNew = await testERC20.balanceOf(addr2.address);
    const addr2BalanceNewNum = addr2BalanceNew.toNumber();
    expect(addr2BalanceNewNum).equal(500);

    const addr3BalanceNew = await testERC20.balanceOf(addr3.address);
    const addr3BalanceNewNum = addr3BalanceNew.toNumber();
    expect(addr3BalanceNewNum).equal(500);
  });
});
