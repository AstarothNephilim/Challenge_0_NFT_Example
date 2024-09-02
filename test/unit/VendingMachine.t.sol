// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployVendingMachine} from  "../../script/DeployVendingMachine.s.sol";
import {VendingMachine} from "../../src/VendingMachine.sol";



contract FundMeTest is Test {
    /// What can we do to work with addresses outside our system?
    // 1. Unit
    //  - Test specific part of the code
    // 2. Integration
    //  - Testing how our code works with other parts of our code
    // 3. Forked
    //  - Testing our code on simulated environment
    // 4. Staging
    // - Testing our code on a real environment that is not prod
    VendingMachine vendingMachine;
    address USER = makeAddr("user");
    uint256 STARTING_BALANCE = 10 ether;
    uint256 GAS_PRICE = 1;

    function setUp() external {
        DeployVendingMachine deployVendingMachine = new DeployVendingMachine();
        // Here I am callign the fundMeTest contract -> The fundMeTest Contract deploys the fundMe -> The fundMe contract is deployed
        vendingMachine = deployVendingMachine.run();
    }


    function testOwnerIsMsgSender() public {

        assertEq(vendingMachine.getOwnerAddress(), msg.sender);
    }



    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        vendingMachine.deposit(); // send 0 value so should revert
    }

    function testFundUpdatesFundedDataStructure() public {
        vendingMachine.deposit{value: 10e18} ();
        uint256 amountFunded = vendingMachine.getAmntFundsFromAddress(address(this));
        assertEq(amountFunded, 10e18);
    }

    function testWithdraw() public {
         //Arrange
        uint256 startingOwnerBalance = vendingMachine.getOwnerAddress().balance;
        uint256 startingVendingMachineBalance = address(vendingMachine).balance;


        // Act
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(vendingMachine.getOwnerAddress());
        vendingMachine.withdrawAll();

        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);

        
    }


}