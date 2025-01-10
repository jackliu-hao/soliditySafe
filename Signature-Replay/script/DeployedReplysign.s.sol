// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import {SigReplay} from "../src/SigReplay.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeploySigReplay is Script {
    address[] public owners; // 多签持有人数组

    function run() external returns (SigReplay sigReplay) {
        owners.push(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        owners.push(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        vm.startBroadcast();
        sigReplay = new SigReplay();
        vm.stopBroadcast();
        console.log("sigReplay  contart address is : %s ", address(sigReplay));
    }
}