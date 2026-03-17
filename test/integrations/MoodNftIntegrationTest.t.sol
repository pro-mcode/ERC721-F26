// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.33;

import {Test, console} from "forge-std/Test.sol";
import {MoodNFT} from "../../src/MoodNFT.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNftTest is Test {
    DeployMoodNft deployer;
    MoodNFT public moodNft;

    address public USER;
    address public OTHER_USER;

    string public sadMoodImageURI;
    string public happyMoodImageURI;

    function setUp() public {
        USER = makeAddr("user");
        OTHER_USER = makeAddr("otherUser");

        deployer = new DeployMoodNft();

        string memory sadSvg = vm.readFile("./images/dynamicNft/_sadMood.svg");
        string memory happySvg = vm.readFile("./images/dynamicNft/_happyMood.svg");

        sadMoodImageURI = deployer.svgToImageURI(sadSvg);
        happyMoodImageURI = deployer.svgToImageURI(happySvg);

        moodNft = deployer.run();
    }

    function testMintToken() public {
        vm.prank(USER);
        moodNft.mintToken();

        assertEq(moodNft.ownerOf(0), USER);
        assertEq(moodNft.s_counterId(), 1);

        string memory uri = moodNft.tokenURI(0);
        assertGt(bytes(uri).length, 0);

        console.log("Minted tokenURI:");
        console.log(uri);
    }

    function testTokenUriContainsHappyImageAfterMint() public {
        vm.prank(USER);
        moodNft.mintToken();

        string memory uri = moodNft.tokenURI(0);

        assertTrue(_tokenUriContainsImage(uri, 0, happyMoodImageURI));
    }

    function testFlipMoodToSad() public {
        vm.startPrank(USER);
        moodNft.mintToken();
        moodNft.flipMood(0);
        vm.stopPrank();

        string memory uri = moodNft.tokenURI(0);

        console.log("Flipped tokenURI:");
        console.log(uri);

        assertTrue(_tokenUriContainsImage(uri, 0, sadMoodImageURI));
    }

    function testFlipMoodBackToHappy() public {
        vm.startPrank(USER);
        moodNft.mintToken();
        moodNft.flipMood(0);
        moodNft.flipMood(0);
        vm.stopPrank();

        string memory uri = moodNft.tokenURI(0);

        assertTrue(_tokenUriContainsImage(uri, 0, happyMoodImageURI));
    }

    function testNonOwnerCannotFlipMood() public {
        vm.prank(USER);
        moodNft.mintToken();

        vm.prank(OTHER_USER);
        vm.expectRevert(MoodNFT.MoodNft_CantFlipMoodIfNotOwner.selector);
        moodNft.flipMood(0);
    }

    function testTokenCounterIncrementsCorrectly() public {
        vm.startPrank(USER);
        moodNft.mintToken();
        moodNft.mintToken();
        vm.stopPrank();

        assertEq(moodNft.s_counterId(), 2);
        assertEq(moodNft.ownerOf(0), USER);
        assertEq(moodNft.ownerOf(1), USER);
    }

    function _tokenUriContainsImage(
        string memory tokenUri,
        uint256 tokenId,
        string memory expectedImageUri
    ) internal pure returns (bool) {
        string memory prefix = "data:application/json;base64,";
        bytes memory tokenUriBytes = bytes(tokenUri);
        bytes memory prefixBytes = bytes(prefix);

        if (tokenUriBytes.length < prefixBytes.length) {
            return false;
        }

        for (uint256 i = 0; i < prefixBytes.length; i++) {
            if (tokenUriBytes[i] != prefixBytes[i]) {
                return false;
            }
        }

        bytes memory encodedJson = new bytes(tokenUriBytes.length - prefixBytes.length);
        for (uint256 i = 0; i < encodedJson.length; i++) {
            encodedJson[i] = tokenUriBytes[i + prefixBytes.length];
        }

        string memory expectedJson = string(
            abi.encodePacked(
                '{"name": "MoodNFT #',
                vm.toString(tokenId),
                '", "description": "An NFT that changes based on the mood of the owner.", "image": "',
                expectedImageUri,
                '"}'
            )
        );

        string memory expectedEncodedJson = Base64.encode(bytes(expectedJson));

        return keccak256(encodedJson) == keccak256(bytes(expectedEncodedJson));
    }
}