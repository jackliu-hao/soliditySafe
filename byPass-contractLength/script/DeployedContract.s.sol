// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import {ContractCheck} from "../src/ContractCheck.sol";
import {NotContract} from "../src/NotContract.sol";
import {Script, console} from "forge-std/Script.sol";


contract DeployedRandom is Script {
    function run() external returns (ContractCheck contractCheck ,NotContract notContract) {
        vm.startBroadcast();
        contractCheck = new ContractCheck();
        notContract = new NotContract(address(contractCheck));
        vm.stopBroadcast();
        console.log("contractCheck  contart address is : %s ", address(contractCheck));
        console.log("notContract  contart address is : %s ", address(notContract));

    }
}