//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


//* 部署自己的 ERC20 合约 MyToken


contract MyToken {
    address minter;

    constructor () ERC20("MyToken", "MT"){
        minter = msg.sender;
    }

    function mint(address account, uint256 amount) public {
        require(msg.sender == minter, "mint not allowed");
        _mint(account, amount);
    }
}
