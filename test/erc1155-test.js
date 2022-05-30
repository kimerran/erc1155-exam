const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("FunToken", function () {
  it("Royalty Test", async function () {
    const [deployer, royaltyOwner, user1, user2] = await ethers.getSigners();

    const FunToken = await ethers.getContractFactory("FunToken");
    const Marketplace = await ethers.getContractFactory("Marketplace");
    const LunaX = await ethers.getContractFactory("LunaX")

    const ft = await FunToken.deploy(royaltyOwner.address);
    const lx = await LunaX.deploy();
    const mp = await Marketplace.deploy(ft.address, lx.address);

    await ft.deployed();
    await mp.deployed();
    await lx.deployed()

    // pre-requisites
    // currency transfer to user2 (buyer)
    // NFT transfer from deployer to user1 (seller)
    await lx.transfer(user2.address, 100);
    await ft.safeTransferFrom(deployer.address, user1.address, 1, 1, []);
    // const res2 = await ft.balanceOf(user2.address, 1)

    // simulate
    // console.log(await sumOfTokens.callStatic.newToken());
    // user1 puts it on sale for 10 wei
    await ft.connect(user1).setApprovalForAll(mp.address, true)
    await mp.connect(user1).sell(1, 10);

    // const sale1 = await mp.getSaleById(1)
    // console.log(sale1)

    // user2 approves marketplace for currency transfer and buys sale#1
    await lx.connect(user2).approve(mp.address, 999)
    await mp.connect(user2).buy(1);

    // check balances
    // console.log( await lx.balanceOf(deployer.address))
    const user1Balance = await lx.balanceOf(user1.address)
    const user2Balance = await lx.balanceOf(user2.address)
    const royaltyBalance = await lx.balanceOf(royaltyOwner.address)

    expect(user1Balance.toString(), "10")
    expect(user2Balance.toString(), "89")
    expect(royaltyBalance.toString(), "1")

    // console.log( await mp.getSaleById(1))
  });
});
