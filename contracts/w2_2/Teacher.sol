// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.0;

interface IScore {
    function addStudent(address studentAddr, string memory name, uint8 score) external;
    function changeScores(string memory name, uint8 score) external;
}

contract Teacher {
    address public admin;
    address public scoreAddr;

    modifier onlyAdmin() {
        require(msg.sender == admin, "only admin can operate!");
        _;
    }

    constructor () {
        admin = msg.sender;
    }

    function setScoreAddress(address _scoreAddr) external onlyAdmin {
        scoreAddr = _scoreAddr;
    }

    function addStudent(address studentAddr, string memory name, uint8 score) external onlyAdmin {
        IScore(scoreAddr).addStudent(studentAddr, name, score);
    }

    function changeScores(string memory name, uint8 score) external onlyAdmin {
        IScore(scoreAddr).changeScores(name, score);
    }
}
