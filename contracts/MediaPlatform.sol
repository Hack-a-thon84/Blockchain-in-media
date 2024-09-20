// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MediaPlatform is Ownable {
    IERC20 public mediaToken;  // ERC20 Token used for payments
    
    struct Content {
        address payable creator;
        string contentHash;    // IPFS or Arweave hash
        uint256 price;         // Price to access the content in tokens
    }

    mapping(uint256 => Content) public contents;
    uint256 public contentCount;

    event ContentUploaded(uint256 indexed contentId, address creator, string contentHash, uint256 price);
    event ContentPurchased(uint256 indexed contentId, address buyer);

    constructor(IERC20 _mediaToken) {
        mediaToken = _mediaToken;
    }

    // Function to upload content
    function uploadContent(string memory _contentHash, uint256 _price) public {
        require(bytes(_contentHash).length > 0, "Content hash cannot be empty");
        require(_price > 0, "Price should be greater than zero");

        contentCount++;
        contents[contentCount] = Content(payable(msg.sender), _contentHash, _price);

        emit ContentUploaded(contentCount, msg.sender, _contentHash, _price);
    }

    // Function to purchase content
    function purchaseContent(uint256 _contentId) public {
        Content memory content = contents[_contentId];
        require(content.creator != address(0), "Content does not exist");
        require(mediaToken.balanceOf(msg.sender) >= content.price, "Insufficient token balance");

        // Transfer tokens to the creator
        require(mediaToken.transferFrom(msg.sender, content.creator, content.price), "Payment failed");

        emit ContentPurchased(_contentId, msg.sender);
    }

    // Fetch content details
    function getContent(uint256 _contentId) public view returns (string memory, uint256) {
        Content memory content = contents[_contentId];
        return (content.contentHash, content.price);
    }
}