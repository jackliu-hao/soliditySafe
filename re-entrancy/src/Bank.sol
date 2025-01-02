// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract Bank {
    mapping(address => uint256) public balanceOf; // 余额mapping

    // 存入ether，并更新余额
    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    // 提取msg.sender的全部ether
    function withdraw() external {
        uint256 balance = balanceOf[msg.sender]; // 获取余额
        require(balance > 0, "Insufficient balance");
        // 转账 ether !!! 可能激活恶意合约的fallback/receive函数，有重入风险！
        (bool success,) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");
        // 更新余额
        balanceOf[msg.sender] = 0;
    }

    // 获取银行合约的余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // 获取指定用户的余额
    function getUserBalance() external view returns (uint256) {
        return balanceOf[msg.sender];
    }
    //获取ETH全部余额，不仅仅是在银行的

    function getAllBalance() external view returns (uint256) {
        return address(msg.sender).balance;
    }
}
