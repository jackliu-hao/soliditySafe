// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import {Random} from "../src/Random.sol";
import {BadRandomness} from "../src/BadRandomness.sol";
import {Attack} from "../src/Attack.sol";

import {Script, console} from "forge-std/Script.sol";


contract DeployedRandom is Script {
    function run() external returns (Random randmom ,BadRandomness badRandomness, Attack attack) {
        vm.startBroadcast();
        randmom = new Random();
        badRandomness = new BadRandomness();
        attack = new Attack();
        vm.stopBroadcast();
        console.log("randmom  contart address is : %s ", address(randmom));
        console.log("badRandomness  contart address is : %s ", address(badRandomness));
        console.log("attack  contart address is : %s ", address(attack));
    }
}