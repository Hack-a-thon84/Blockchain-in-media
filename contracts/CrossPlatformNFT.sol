// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CrossPlatformNFT is ERC721 {
    mapping(uint256 => string) public platformUtility;  // Metadata for cross-platform utility

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    // Mint a new NFT with cross-platform utility metadata
    function mintNFT(address recipient, uint256 tokenId, string memory utility) public {
        _mint(recipient, tokenId);
        platformUtility[tokenId] = utility;
    }

    // Fetch cross-platform utility information
    function getPlatformUtility(uint256 tokenId) public view returns (string memory) {
        return platformUtility[tokenId];
    }
}
