// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {VendingMachine} from "../src/VendingMachine.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract DepositMyMoneyInteraction is Script {
    uint256 constant SEND_VALUE = 0.01 ether;
    address sender = vm.addr(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

    // Here goes the function that funds the contract
    function fundVendingMachine(address mostRecentlyDeployed) public {
        vm.deal(sender,100000000000000000);
        vm.startBroadcast(sender);
        console.log("Most Recently Deployed: ", mostRecentlyDeployed);
        VendingMachine(payable(mostRecentlyDeployed)).deposit{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded VendingMachine with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "VendingMachine",
            block.chainid
        );
        console.log("Contrato extraido con DevOps: ", mostRecentlyDeployed);
        fundVendingMachine(mostRecentlyDeployed);

    }
}


contract DepositSeveralUsersFundsInteraction is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFromArrayOfUsers(address[] memory userArray, address mostRecentlyDeployed) public {
        for(uint256 i = 0; i < userArray.length; i++) {
            vm.deal(userArray[i],100000000000000000);
            console.log("Will use this address: ", userArray[i]);
            vm.startBroadcast(userArray[i]);
            VendingMachine(payable(mostRecentlyDeployed)).deposit{value: SEND_VALUE}();
            vm.stopBroadcast();
        }
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "VendingMachine",
            block.chainid
        );
        console.log("Contrato extraido con DevOps: ", mostRecentlyDeployed);

    }
}


// This script is setUp to test the functionality in Anvil.
contract DepositAndWithdrawMyMoney is Script {
    uint256 public sendValue;
    address[] public users;


    function setUp() public {
        sendValue = vm.envUint("SEND_VALUE");
        users =  loadUsersFromEnv();
    }

    function loadUsersFromEnv() internal returns(address[] memory) {
        uint256 user_count = vm.envUint("USER_COUNT");
        address[] memory users = new address[](user_count);

        for(uint256 i = 0; i < user_count; i++) {
            string memory privateKeyVar  = string(abi.encodePacked("PRIVATE_KEY_", Strings.toString(i)));
            uint256 privateKey = vm.envUint(privateKeyVar);
            users[i] = vm.addr(privateKey);
        }
        return users;    
    }

function fundFromArrayOfUsers(address mostRecentlyDeployed) public {
    for(uint256 i = 0; i < users.length; i++) {
        address user = users[i];
        vm.startBroadcast(user);
        VendingMachine(payable(mostRecentlyDeployed)).deposit{value: sendValue}();
        vm.stopBroadcast();
    }
}

    function run() external {
        // Use ANVIL_RPC_URL and ANVIL_CHAIN_ID
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "VendingMachine",
            vm.envUint("ANVIL_CHAIN_ID")
        );
        fundFromArrayOfUsers(mostRecentlyDeployed);
    }
}
