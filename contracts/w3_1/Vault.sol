// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//W3_1作业
//* 发⾏⼀个 ERC20 Token：
//* 可动态增发（起始发⾏量是 0）
//* 通过 ethers.js. 调⽤合约进⾏转账
//* 编写⼀个Vault 合约：
//* 编写deposite ⽅法，实现 ERC20 存⼊ Vault，并记录每个⽤户存款⾦额 ， ⽤从前端调⽤（Approve，transferFrom）
//* 编写 withdraw ⽅法，提取⽤户⾃⼰的存款 （前端调⽤）
//* 前端显示⽤户存款⾦额

contract Vault {
    address token;

    event LogDeposit(address indexed user, uint amount);
    event LogWithdraw(address indexed user, uint amount);

    constructor(address _token) {
        token = _token;
    }

    // address => user amount
    mapping(address => uint256) public accountBalance;

    function deposit(uint256 _amount) external {
        IERC20(token).transferFrom(msg.sender, address(this), _amount);
        accountBalance[msg.sender] += _amount;
        emit LogDeposit(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) external {
        require(_amount <= accountBalance[msg.sender], "amount not enough");
        accountBalance[msg.sender] -= _amount;
        IERC20(token).transfer(msg.sender, _amount);
        emit LogWithdraw(msg.sender, _amount);
    }

    receive() external payable {
        // 用户充错链币直接退钱
        payable(msg.sender).transfer(msg.value);
    }
}
