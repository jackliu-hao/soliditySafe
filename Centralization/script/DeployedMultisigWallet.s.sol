// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import {MultisigWallet} from "../src/MultisigWallet.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployMultisigWallet is Script {
    address[] public owners; // 多签持有人数组

    function run() external returns (MultisigWallet multisigWallet) {
        owners.push(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        owners.push(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        vm.startBroadcast();
        multisigWallet = new MultisigWallet(owners, 2);
        vm.stopBroadcast();
        console.log("multisigWallet  contart address is : %s ", address(multisigWallet));
    }
}
