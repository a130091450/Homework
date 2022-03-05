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
    // 部署teacher合约
    const Teacher = await hre.ethers.getContractFactory("Teacher");
    const teacher = await Teacher.deploy();
    await teacher.deployed();
    console.log("teacher deployed to:", teacher.address);

    // 部署score合约
    const Score = await hre.ethers.getContractFactory("Score");
    const score = await Score.deploy(teacher.address);
    await score.deployed();
    console.log("score deployed to:", score.address);
    await teacher.setScoreAddress(score.address);

    // teacher增加学生成绩
    teacher.addStudent("0xD4Ac560CB110c1dBff3d1B2906d36cA07eEDB8aC", "jack", 50);
    teacher.addStudent("0xd4dE3e2012210B381e404A6A8DE11092096D9237", "mike", 70);
    teacher.addStudent("0x4A37B7B13d83bA7B49D5b35BC7BA403689b8b9B8", "alice", 30);

    console.log(await score.name2address("jack"));


}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
