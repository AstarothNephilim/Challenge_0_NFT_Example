// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {VendingMachine} from "../src/VendingMachine.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployVendingMachine is Script {

    function run() external returns (VendingMachine) {

        //Creates a hel
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        VendingMachine vendingMachine = new VendingMachine();
        vm.stopBroadcast();
        return vendingMachine;
    }
    
}

