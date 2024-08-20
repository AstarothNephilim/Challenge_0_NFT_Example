// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {VendingMachine} from "../../src/VendingMachine.sol";
import {DeployVendingMachine} from "../../script/DeployVendingMachine.s.sol";
import {DepositMyMoneyInteraction} from "../../script/Interactions.s.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract FundVendingTestIntegration is Test {
    VendingMachine vendingMachine;


    // This creates an address derived from the name provided
    address USER = makeAddr("user");
    address[] USERS;
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;
    
    function setUp() external {
        DeployVendingMachine deployVendingMachine = new DeployVendingMachine();
        vendingMachine = deployVendingMachine.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function createUsers() public returns(address[] memory) {
        address[] memory users = new address[](5);
        for (uint256 i = 0; i < 5; i++) {
            users[i] =  makeAddr(string(abi.encodePacked("user", Strings.toString(i + 1))));
        }
        return users;
    }

    function testUserCanDeposit() public {
        DepositMyMoneyInteraction depositMyMoneyInteraction = new DepositMyMoneyInteraction();
        depositMyMoneyInteraction.fundVendingMachine(address(vendingMachine));    
    }


}