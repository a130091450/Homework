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
    // 部署bank合约
    const Bank = await hre.ethers.getContractFactory("BankSafe");
    const bank = await Bank.deploy();
    await bank.deployed();
    console.log("Bank deployed to:", bank.address);

    const [owner, user1, user2] = await hre.ethers.getSigners();
    // 账号1 充值
    let depositNum1 = "2";
    await bank.connect(user1).deposit({value: hre.ethers.utils.parseEther(depositNum1)});
    expect(await bank.accountBalance(user1.address)).to.equal(new BigNumber(10**18).multipliedBy(new BigNumber(depositNum1)).toFixed());

    // 账号2 充值
    let depositNum2 = "20";
    await bank.connect(user2).deposit({value: hre.ethers.utils.parseEther(depositNum2)});
    expect(await bank.accountBalance(user2.address)).to.equal(new BigNumber(10**18).multipliedBy(new BigNumber(depositNum2)).toFixed());

    // 账号2 直接转链币到bank，bank会退钱
    let bankBalance1 = await web3.eth.getBalance(bank.address);
    var message = {from: user2.address, to:bank.address, value: hre.ethers.utils.parseEther("3")};
    await web3.eth.sendTransaction(message);
    let bankBalance2 = await web3.eth.getBalance(bank.address);
    // 验证合约中链币余额为不变
    expect(bankBalance1).to.equal(bankBalance2);

    // 验证bank合约地址中应该有22个链币
    let bankBalance = getHumanBalance(await web3.eth.getBalance(bank.address));
    expect(bankBalance).to.equal("22");

    // 账号2 提取10个链币走, bank中应该还剩10个链币
    let account2BalanceBefore = await web3.eth.getBalance(user2.address);
    await bank.connect(user2).withdraw(hre.ethers.utils.parseEther("10"));
    let account2BalanceAfter = await web3.eth.getBalance(user2.address);
    let withdrawAmount = account2BalanceAfter - account2BalanceBefore;
    console.log("用户2提币,其地址账号币数量涨了大约" + getHumanBalance(withdrawAmount) + "个");
    expect(await bank.accountBalance(user2.address)).to.equal(new BigNumber(10**18).multipliedBy(new BigNumber("10")).toFixed());

    // owner提取bank中所有的币
    await bank.withdrawAll();
    expect(await web3.eth.getBalance(bank.address)).to.equal("0");

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
