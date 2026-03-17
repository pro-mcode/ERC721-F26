// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.33;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract MoodNFT is ERC721 {

    error MoodNft_CantFlipMoodIfNotOwner();

    uint256 public s_counterId = 0;
    string public s_sadMoodImageURI;
    string public s_happyMoodImageURI;

    enum Mood {
        HAPPY,
        SAD,
        NEUTRAL
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    function _baseURI() internal override pure returns (string memory) {
       return "data:application/json;base64,";
    }
    
    constructor(
        string memory _sadMoodImageURI,
        string memory _happyMoodImageURI
    ) ERC721("MoodNFT", "MOOD") { 
        s_sadMoodImageURI = _sadMoodImageURI;
        s_happyMoodImageURI = _happyMoodImageURI;
    }

    function mintToken() public {
        _safeMint(msg.sender, s_counterId);
        s_tokenIdToMood[s_counterId] = Mood.HAPPY;
        s_counterId++;
    }

    function flipMood(uint256 tokenId) public {
        // if (!_isApprovedOrOwner(msg.sender, tokenId)) {
        // revert MoodNft_CantFlipMoodIfNotOwner();
        // }
        if (ownerOf(tokenId) != msg.sender && getApproved(tokenId) != msg.sender && !isApprovedForAll(ownerOf(tokenId), msg.sender)) {
        revert MoodNft_CantFlipMoodIfNotOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI = s_tokenIdToMood[tokenId] == Mood.HAPPY ? s_happyMoodImageURI : s_sadMoodImageURI;
        string memory metadata = Base64.encode(
            bytes(
                string(abi.encodePacked(
                    '{"name": "MoodNFT #', Strings.toString(tokenId), '", "description": "An NFT that changes based on the mood of the owner.", "image": "', imageURI, '"}'
                ))
            )
        );
        return string(abi.encodePacked(_baseURI(), metadata));
    }

    function getMood(uint256 tokenId) public view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }
}