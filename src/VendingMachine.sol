// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/console.sol";


contract VendingMachine {
    uint256 public userFunds;
    address public immutable i_owner;
    address[] public s_funders;

    constructor() {
        i_owner = msg.sender;
    } 

    modifier OnlyOwner {
        if (i_owner != msg.sender) revert();
        _;
    }

    mapping(address => uint256) s_AddressToFunds;

    function deposit() payable public {
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
}