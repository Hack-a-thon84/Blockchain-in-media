pragma solidity ^0.8.0;

contract MediaRoyalties is MediaPlatform {
    mapping(uint256 => address) public contentOwner;
    uint256 public royaltyPercentage = 5; // 5% royalty

    event ContentResold(uint256 indexed contentId, address seller, address buyer);

    // Purchase content and enable resale
    function resellContent(uint256 _contentId, uint256 _price, address _buyer) public {
        require(contentOwner[_contentId] == msg.sender, "Only owner can resell");
        require(mediaToken.balanceOf(_buyer) >= _price, "Insufficient token balance");

        // Calculate royalty
        uint256 royalty = (_price * royaltyPercentage) / 100;
        uint256 sellerAmount = _price - royalty;

        // Transfer royalty to original creator
        Content memory content = contents[_contentId];
        require(mediaToken.transferFrom(_buyer, content.creator, royalty), "Royalty payment failed");

        // Transfer remaining amount to seller
        require(mediaToken.transferFrom(_buyer, msg.sender, sellerAmount), "Payment to seller failed");

        // Update ownership
        contentOwner[_contentId] = _buyer;

        emit ContentResold(_contentId, msg.sender, _buyer);
    }

    // Set royalty percentage
    function setRoyaltyPercentage(uint256 _percentage) public onlyOwner {
        royaltyPercentage = _percentage;
    }
}
