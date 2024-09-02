// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/console.sol";


contract VendingMachine {
    uint256 private userFunds;
    address private immutable i_owner;
    address[] private s_funders;

    constructor() {
        i_owner = msg.sender;
    } 

    modifier OnlyOwner {
        if (i_owner != msg.sender) revert();
        _;
    }

    mapping(address => uint256) s_AddressToFunds;

    function deposit() payable public {
        require(msg.value > 0, "SEND MONEY!");
        s_AddressToFunds[msg.sender] += msg.value;
        userFunds += msg.value;
        s_funders.push(msg.sender);
        console.log("Deposit from:", msg.sender);
        console.log("Amount deposited:", msg.value);
        console.log("New balance for sender:", s_AddressToFunds[msg.sender]);
        console.log("Total userFunds:", userFunds);
    }

    function getBalance(address account) public view returns (uint256) {
        return s_AddressToFunds[account];
    }

    function withdrawAll() public OnlyOwner {
        for(uint256 addressIdx = 0; addressIdx < s_funders.length; addressIdx++) {
            address funder = s_funders[addressIdx];
            s_AddressToFunds[funder] = 0;
        }

        // Set array[] to new array
        s_funders = new address[](0);


        // Give me all the money using call. It returns bool
        (bool success,) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    function cheaperWithdraw() public OnlyOwner {
        // Reading / Writing from/in storage is expensive. Minimize this:
        uint256 fundersLength = s_funders.length;
        for(uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_AddressToFunds[funder] = 0;
        }
        s_funders = new address[](0);
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getAmntFundsFromAddress(address funderAddres) public view returns (uint256) {
        uint256 value = s_AddressToFunds[funderAddres];
        return(value);

    }

    function getFunders() public view returns (address[] memory) {
        return s_funders;
    }

    
    function getOwnerAddress() public view returns (address) {

        return i_owner;
    }
}