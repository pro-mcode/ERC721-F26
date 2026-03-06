// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.33;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract LayerNFT is ERC721 {
    uint256 private s_tokenIdCounter;

    mapping (uint256 => string) private s_tokenIdToURIs;
    

    constructor() ERC721("LayerNFT", "LAYER") {
        s_tokenIdCounter = 0;
    }

    function mintNft(string memory tokenUri) external {
        s_tokenIdToURIs[s_tokenIdCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenIdCounter);
        s_tokenIdCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToURIs[tokenId];
    }

}