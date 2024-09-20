// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CreatorAnalytics {
    struct ContentStats {
        uint256 views;
        uint256 likes;
        uint256 purchases;
    }

    mapping(uint256 => ContentStats) public contentStats;

    event ContentViewed(uint256 indexed contentId, address viewer);
    event ContentLiked(uint256 indexed contentId, address liker);
    event ContentPurchased(uint256 indexed contentId, address buyer);

    // Record a view for specific content
    function recordView(uint256 _contentId) public {
        contentStats[_contentId].views += 1;
        emit ContentViewed(_contentId, msg.sender);
    }

    // Record a like for specific content
    function recordLike(uint256 _contentId) public {
        contentStats[_contentId].likes += 1;
        emit ContentLiked(_contentId, msg.sender);
    }

    // Record a purchase for specific content (called after purchase in NFT contract)
    function recordPurchase(uint256 _contentId) public {
        contentStats[_contentId].purchases += 1;
        emit ContentPurchased(_contentId, msg.sender);
    }

    // Get stats for content
    function getContentStats(uint256 _contentId) public view returns (uint256 views, uint256 likes, uint256 purchases) {
        ContentStats memory stats = contentStats[_contentId];
        return (stats.views, stats.likes, stats.purchases);
    }
}
