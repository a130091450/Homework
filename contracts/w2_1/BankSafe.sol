// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.0;

import "./TransferHelper.sol";

contract BankSafe {

    address owner;
    bool locked;

    event LogDeposit(address indexed user, uint amount);
    event LogWithdraw(address indexed user, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call the function!");
        _;
    }

    modifier nonReentrancy() {
        require(!locked, "no reentrancy");
        locked = true;
        _;
        locked = false;
    }

    constructor() {
        owner = msg.sender;
    }

    // address => user amount
    mapping(address => uint256) public accountBalance;

    function deposit() external payable {
        accountBalance[msg.sender] += msg.value;
        emit LogDeposit(msg.sender, msg.value);
    }

    function withdraw(uint amount) external nonReentrancy {
        require(accountBalance[msg.sender] >= amount, "your balance not enough!");
        accountBalance[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}(new bytes(0));
        require(success, "withdraw fail!");
        emit LogWithdraw(msg.sender, amount);
    }

    function withdrawAll() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {
        // 直接打钱而不通过充值函数的退钱
        payable(msg.sender).transfer(msg.value);
    }
}
