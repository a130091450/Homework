// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//* 发⾏⼀个 ERC20 Token：
//* 可动态增发（起始发⾏量是 0）
//* 通过 ethers.js. 调⽤合约进⾏转账
contract DiamondDemo is ERC20 {
    address minter;

    constructor () ERC20("Diamond", "DIA"){
        minter = msg.sender;
    }

    function mint(address account, uint256 amount) public {
        require(msg.sender == minter, "mint not allowed");
        _mint(account, amount);
    }
}

