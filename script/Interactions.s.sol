// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {VendingMachine} from "../src/VendingMachine.sol";

contract DepositMyMoneyInteraction is Script {
    uint256 constant SEND_VALUE = 0.01 ether;


    // Here goes the function that funds the contract
    function fundVendingMachine(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        VendingMachine(payable(mostRecentlyDeployed)).deposit{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded VendingMachine with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "VendingMachine",
            block.chainid
        );
        vm.startBroadcast();
        fundVendingMachine(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}


contract WithdrawMyMoney is Script {


    function setUp() public {}

    function run() external {
        vm.startBroadcast();

        

        vm.stopBroadcast();
    }
}
