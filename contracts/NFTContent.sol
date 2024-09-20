// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTContent is ERC721URIStorage, Ownable {
    IERC20 public mediaToken;  // Platform token used for transactions
    uint256 public nextTokenId = 1;
    uint256 public mintPrice = 100 * (10 ** 18);  // Price to mint a new content NFT

    mapping(uint256 => uint256) public royalties;  // Royalties as a percentage of sales (e.g., 5%)
    mapping(uint256 => address) public creators;   // Creator of the content NFT

    event ContentMinted(uint256 indexed tokenId, address creator, string uri);
    event ContentPurchased(uint256 indexed tokenId, address buyer, uint256 price);

    constructor(IERC20 _mediaToken) ERC721("NFTContent", "MEDIA") {
        mediaToken = _mediaToken;
    }

    // Mint a new content NFT
    function mintContent(string memory _tokenURI, uint256 _royaltyPercentage) public {
        require(_royaltyPercentage <= 100, "Invalid royalty percentage");

        uint256 tokenId = nextTokenId;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        creators[tokenId] = msg.sender;
        royalties[tokenId] = _royaltyPercentage;

        nextTokenId += 1;
        emit ContentMinted(tokenId, msg.sender, _tokenURI);
    }

    // Purchase content NFT directly from the platform
    function purchaseContent(uint256 tokenId, uint256 _price) public {
        address creator = creators[tokenId];
        require(creator != address(0), "Content not found");
        require(_price > 0, "Price must be greater than zero");

        uint256 royaltyFee = (_price * royalties[tokenId]) / 100;
        uint256 creatorAmount = _price - royaltyFee;

        mediaToken.transferFrom(msg.sender, creator, creatorAmount);  // Transfer to creator
        mediaToken.transferFrom(msg.sender, owner(), royaltyFee);     // Transfer royalties to platform

        emit ContentPurchased(tokenId, msg.sender, _price);
    }

    // Set the mint price for content
    function setMintPrice(uint256 _mintPrice) public onlyOwner {
        mintPrice = _mintPrice;
    }
}
