// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.33;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract LayerNFT is ERC721 {
    uint256 public tokenIdCounter;
    

    constructor() ERC721("LayerNFT", "LAYER") {}

    function mint(address to) external {
        _safeMint(to, tokenIdCounter);
        tokenIdCounter++;
    }

    functiom tokenURI() public view returns (string memory) {
        return "https://example.com/layer-nft-metadata.json";
    }

}