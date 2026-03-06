// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.33;

import {Script} from "forge-std/Script.sol";
import {LayerNFT} from "../src/LayerNFT.sol";

contract DeployLayerNft is Script {
     function run() public returns (LayerNFT) {
        vm.startBroadcast();
        LayerNFT layerNft = new LayerNFT();
        vm.stopBroadcast();
        return layerNft;
     }
}