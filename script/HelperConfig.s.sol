// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";

contract HelperConfig is Script {

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if(block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaNetworkConfig();
        }
        else {
            // Here I would have to get the Anvil Config
            activeNetworkConfig = getSepoliaNetworkConfig();
        }

    }

    function getSepoliaNetworkConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaNetworkConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaNetworkConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
    if (activeNetworkConfig.priceFeed != address(0)) {
        return activeNetworkConfig;
    }

    //1. Deploy the mocks
    //2. Return the mock address

    // STILL HAVE TO IMPLEMENT THE CONTRACT
}

}
