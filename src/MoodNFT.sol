// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.33;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MoodNFT is ERC721 {

    uint256 public s_counterId = 0;
    string public sadMood;
    string public happyMood;
    constructor(
        string memory _sadMood,
        string memory _happyMood
    ) ERC721("MoodNFT", "MOOD") { 
        sadMood = _sadMood;
        happyMood = _happyMood;
    }

    function mintToken() public {
        _safeMint(msg.sender, s_counterId);
        s_counterId++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return "https://ipfs.io/ipfs/QmVb3KZ7y9wZ2E6x9CfXkX7mQxuT9BnZQ2q2jgHJ2J3Y5?token_id=" + tokenId;
    }    
}