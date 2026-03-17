// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.33;

import {Script} from "forge-std/Script.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {

    MoodNFT public moodNft;

    function run() public returns (MoodNFT) {

        string memory sadSvg = vm.readFile("./images/dynamicNft/_sadMood.svg");
        string memory happySvg = vm.readFile("./images/dynamicNft/_happyMood.svg");

        string memory sadURI = svgToImageURI(sadSvg);
        string memory happyURI = svgToImageURI(happySvg);

        vm.startBroadcast();

        moodNft = new MoodNFT(sadURI, happyURI);

        vm.stopBroadcast();

        return moodNft;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {

        string memory prefix = "data:image/svg+xml;base64,";

        string memory encodedSvg = Base64.encode(
            bytes(svg)
        );

        return string(
            abi.encodePacked(prefix, encodedSvg)
        );
    }
}