// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DynamicPricingNFT {
    struct NFT {
        uint256 price;
        uint256 views;
        uint256 likes;
        uint256 purchases;
        bool isListed;
        address owner;
    }

    mapping(uint256 => NFT) public nfts;
    uint256 public priceIncreaseFactor = 10;  // Percentage increase for popular NFTs

    event NFTListed(uint256 indexed tokenId, uint256 price);
    event NFTPurchased(uint256 indexed tokenId, address buyer, uint256 price);
    event PriceUpdated(uint256 indexed tokenId, uint256 newPrice);

    // List an NFT with dynamic pricing
    function listNFT(uint256 _tokenId, uint256 _price) public {
        require(_price > 0, "Price must be greater than zero");
        nfts[_tokenId] = NFT({
            price: _price,
            views: 0,
            likes: 0,
            purchases: 0,
            isListed: true,
            owner: msg.sender
        });

        emit NFTListed(_tokenId, _price);
    }

    // Purchase an NFT and apply dynamic pricing
    function purchaseNFT(uint256 _tokenId) public payable {
        NFT storage nft = nfts[_tokenId];
        require(nft.isListed, "NFT is not listed for sale");
        require(msg.value >= nft.price, "Insufficient funds to purchase");

        address seller = nft.owner;
        nft.owner = msg.sender;
        nft.purchases += 1;
        nft.isListed = false;

        // Transfer funds to the seller
        payable(seller).transfer(msg.value);

        // Adjust the price dynamically based on engagement
        uint256 newPrice = nft.price + (nft.price * priceIncreaseFactor / 100);
        nft.price = newPrice;

        emit NFTPurchased(_tokenId, msg.sender, nft.price);
        emit PriceUpdated(_tokenId, newPrice);
    }

    // Record engagement for dynamic pricing (views/likes)
    function recordEngagement(uint256 _tokenId, uint256 _views, uint256 _likes) public {
        NFT storage nft = nfts[_tokenId];
        nft.views += _views;
        nft.likes += _likes;

        // Increase price based on engagement
        if (nft.views > 100 || nft.likes > 50) {
            uint256 newPrice = nft.price + (nft.price * priceIncreaseFactor / 100);
            nft.price = newPrice;

            emit PriceUpdated(_tokenId, newPrice);
        }
    }
}
