// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {VendingMachine} from "../../src/VendingMachine.sol";
import {DeployVendingMachine} from "../../script/DeployVendingMachine.s.sol";
import {DepositMyMoneyInteraction, DepositSeveralUsersFundsInteraction} from "../../script/Interactions.s.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

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
        console.log("USER: ", USER);
        console.log("FundVendingInteraction CA: ", address(this));
        depositMyMoneyInteraction.fundVendingMachine(address(vendingMachine));
        console.log("CA Deployed", address(vendingMachine));
        address funder = vendingMachine.getFunder(0); 
        console.log("Funder:", funder);
        assertEq(funder,0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    }

    function testSeveralUsersDeposit() public {
        address[] memory users = createUsers();
        DepositSeveralUsersFundsInteraction depositArrayInteraction = new DepositSeveralUsersFundsInteraction();
        console.log("USER: ", USER);
        console.log("FundVendingInteraction CA: ", address(this));
        depositArrayInteraction.fundFromArrayOfUsers(users, address(vendingMachine));

        assertEq(users, vendingMachine.getFunders());

    }

}