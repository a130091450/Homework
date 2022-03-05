// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.0;

//W2_2作业
//* 编写合约Score，⽤于记录学⽣（地址）分数：
//* 仅有⽼师（⽤modifier权限控制）可以添加和修改学⽣分数
//* 分数不可以⼤于 100；
//* 编写合约 Teacher 作为⽼师，通过 IScore 接⼝调⽤修改学⽣分数。

contract Score {
    address teacher;

    struct Score {
        string name;
        uint8 score;
    }

    // student => score
    mapping(address => Score) public scores;
    // student name => address
    mapping(string => address) public name2address;
    // student list
    string[] public students;

    constructor (address _teacher) {
        teacher = _teacher;
    }

    modifier onlyTeacher() {
        require(msg.sender == teacher, "only teacher can call the function!");
        _;
    }

    modifier scoreCheck(uint8 score) {
        require(score <= 100, "score can not exceed 100");
        _;
    }

    function addStudent(address studentAddr, string memory name, uint8 score) external onlyTeacher scoreCheck(score) {
        students.push(name);
        name2address[name] = studentAddr;
        scores[studentAddr] = Score(name, score);
    }

    function changeScores(string memory name, uint8 score) external onlyTeacher scoreCheck(score) {
        require(name2address[name] != address(0), "student not exist!");
        scores[name2address[name]] = Score(name, score);
    }
}
