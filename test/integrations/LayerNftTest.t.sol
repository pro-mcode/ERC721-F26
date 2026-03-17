// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {LayerNFT} from "../../src/LayerNFT.sol";
import {DeployLayerNft} from "../../script/DeployLayerNft.s.sol";

contract LayerNftTest is Test {
    DeployLayerNft public deployer;
    LayerNFT public layerNft;
    address public USER = makeAddr("user");
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployLayerNft();
        layerNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory actualName = layerNft.name();
        string memory expectedName = "LayerNFT";

        assert(keccak256(abi.encodePacked(actualName)) == keccak256(abi.encodePacked(expectedName)));
    }

    function testMintNft() public {
        vm.prank(USER);
        layerNft.mintNft(PUG);

        assert(keccak256(abi.encodePacked(layerNft.tokenURI(0))) == keccak256(abi.encodePacked(PUG)));
        assert(layerNft.balanceOf(USER) == 1);


    }

//      function testMintNftMultiple() public {
//         layerNft.mintNft("https://example.com/1");
//         layerNft.mintNft("https://example.com/2");
//         assert(layerNft.tokenURI(0) == "https://example.com/1");
//         assert(layerNft.tokenURI(1) == "https://example.com/2");
//      }

}