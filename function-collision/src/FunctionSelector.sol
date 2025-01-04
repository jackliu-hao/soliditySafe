// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract FunctionSelector{

    //获取函数的全部hash值
    function getFunctionHash(string memory functionName ) public pure returns(bytes32 fullHash){
        // 获取函数签名的 Keccak256 哈希值
        fullHash = keccak256(abi.encodePacked(functionName));
    }
    // 获取函数的selector
    function getFunctionSelector(string memory functionName ) public pure returns(bytes4 selector){
        // 获取函数签名的 Keccak256 哈希值
        bytes32 fullHash = keccak256(abi.encodePacked(functionName));
        // 取前四个字节作为函数选择器
        selector = bytes4(fullHash);
    }

}