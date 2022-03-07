const { expect } = require("chai");
const hre = require("hardhat");
const BigNumber = require('bignumber.js');
const Web3 = require('web3');

var web3 = new Web3('http://127.0.0.1:8545');

// 获取人类视觉上的余额
function getHumanBalance(balance) {
    return new BigNumber(balance).div(new BigNumber(10**18)).toFixed();
}


async function main() {
    const [owner, user1, user2] = await hre.ethers.getSigners();

    // 部署bank合约
    const Bank = await hre.ethers.getContractFactory("BankDanger");
    const bank = await Bank.deploy();
    await bank.deployed();
    console.log("Bank deployed to:", bank.address);

    // 用户2向合约中存55个eth
    let depositNum = "30";
    await bank.connect(user2).deposit({value: hre.ethers.utils.parseEther(depositNum)});
    expect(await web3.eth.getBalance(bank.address)).to.equal(hre.ethers.utils.parseEther(depositNum));
    console.log("bank合约余额:", getHumanBalance(await web3.eth.getBalance(bank.address)));

    // 部署attack合约
    const Attacker = await hre.ethers.getContractFactory("BankAttacker");
    const attacker = await Attacker.deploy(bank.address, {value: ethers.utils.parseEther("10")});
    await attacker.deployed();
    console.log("attaker deployed to:", attacker.address);

    console.log("attaker合约余额:", getHumanBalance(await web3.eth.getBalance(attacker.address)));
    await attacker.attackIt({value: ethers.utils.parseEther("1")});
    console.log("attaker合约余额:", getHumanBalance(await web3.eth.getBalance(attacker.address)));
    console.log("bank合约余额:", getHumanBalance(await web3.eth.getBalance(bank.address)));
    consol.log("测试结束");

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
