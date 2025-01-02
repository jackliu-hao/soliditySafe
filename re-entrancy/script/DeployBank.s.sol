// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import {Bank} from "../src/Bank.sol";
import {Eval} from "../src/Eval.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployBank is Script {
    function run() external returns (Bank bank , Eval eval) {
        vm.startBroadcast();
        bank = new Bank();
        // 部署eval合约
        eval = new Eval(bank);
        vm.stopBroadcast();
        console.log("bank  contart address is : %s ", address(bank));
        console.log("eval  contart address is : %s ", address(eval));
    }
}
