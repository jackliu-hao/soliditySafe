// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 用extcodesize检查是否为合约地址
contract ContractCheck is ERC20 {
    // 构造函数：初始化代币名称和代号
    constructor() ERC20("", "") {}

    // 利用 extcodesize 检查是否为合约
    function isContract(address account) public view returns (bool) {
        // extcodesize > 0 的地址一定是合约地址
        // 但是合约在构造函数时候 extcodesize 为0
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    // mint函数，只有非合约地址能调用（有漏洞）
    function mint() public {
        require(!isContract(msg.sender), "Contract not allowed!");
        _mint(msg.sender, 100);
    }

    function safeMint() public {
        require(!realContract(msg.sender), "Contract not allowed!");
        _mint(msg.sender, 100);
    }

    function realContract(address account) public view returns (bool) {
        return (tx.origin == msg.sender);
    }
}
