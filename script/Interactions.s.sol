// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Script} from "forge-std/Script.sol";
import {LayerNFT} from "../src/LayerNFT.sol";
import {DevOpsTools } from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintLayerNft is Script {
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    function run() public {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("LayerNFT", block.chainid);
        mintLayerNft(mostRecentDeployed);
    }

    function mintLayerNft(address LayerNFTAddress) public {
        vm.startBroadcast();
        LayerNFT(LayerNFTAddress).mintNft(PUG);
        vm.stopBroadcast();
    }


}