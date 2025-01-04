// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract Bank {
    mapping(address => uint256) public balanceOf; // 余额mapping
    uint256 private _status; // 重入锁
    
    // 重入锁
    // 在solidity中，修饰器和Java中的AOP一样
    modifier nonReentrant() {
        require(_status == 0 , "ReentrancyGuard: reentrant call");
        _status = 1;
        _;  //这里就是函数调用
        //调用结束，需要把 _status 恢复为0
        _status = 0;
    }

    // 存入ether，并更新余额
    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    // 提取msg.sender的全部ether
    // 这里加上重入锁，防止重入攻击
    function withdraw() external  nonReentrant {
        uint256 balance = balanceOf[msg.sender]; // 获取余额
        require(balance > 0, "Insufficient balance");
        // 更新余额
        (bool success,) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");
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
