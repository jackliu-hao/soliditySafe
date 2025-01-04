// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import {SelectorClash} from "../src/SelectorClash.sol";
import {FunctionSelector} from "../src/FunctionSelector.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployFunctionSelect is Script {
    function run() external returns (SelectorClash selectorClash,FunctionSelector functionSelector) {
        vm.startBroadcast();
        selectorClash = new SelectorClash();
        functionSelector = new FunctionSelector();
        vm.stopBroadcast();
        console.log("functionSelector  contart address is : %s ", address(functionSelector));
        console.log("selectorClash  contart address is : %s ", address(selectorClash));
    }
}
