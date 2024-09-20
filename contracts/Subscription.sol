// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Subscription {
    IERC20 public mediaToken;  // Platform token
    uint256 public subscriptionPrice = 50 * (10 ** 18);  // Monthly subscription price
    uint256 public payPerViewPrice = 10 * (10 ** 18);    // Pay-per-view price for individual content

    struct SubscriptionInfo {
        uint256 startTime;
        uint256 duration; // Subscription duration in seconds
    }

    mapping(address => SubscriptionInfo) public subscriptions;
    mapping(address => bool) public payPerViewAccess;  // Track users who paid for specific content

    event Subscribed(address indexed user, uint256 duration);
    event PayPerViewAccessGranted(address indexed user);

    constructor(IERC20 _mediaToken) {
        mediaToken = _mediaToken;
    }

    // Subscribe for 1 month (or extend existing subscription)
    function subscribe() public {
        require(mediaToken.balanceOf(msg.sender) >= subscriptionPrice, "Insufficient funds");

        SubscriptionInfo storage info = subscriptions[msg.sender];
        uint256 currentTime = block.timestamp;
        uint256 duration = 30 days;

        // Update subscription duration
        if (currentTime < info.startTime + info.duration) {
            info.duration += duration;  // Extend subscription
        } else {
            info.startTime = currentTime;
            info.duration = duration;
        }

        mediaToken.transferFrom(msg.sender, address(this), subscriptionPrice);
        emit Subscribed(msg.sender, info.duration);
    }

    // Purchase pay-per-view access for specific content
    function payPerView() public {
        require(mediaToken.balanceOf(msg.sender) >= payPerViewPrice, "Insufficient funds");

        payPerViewAccess[msg.sender] = true;
        mediaToken.transferFrom(msg.sender, address(this), payPerViewPrice);
        emit PayPerViewAccessGranted(msg.sender);
    }

    // Check if user is subscribed
    function isSubscribed(address user) public view returns (bool) {
        SubscriptionInfo storage info = subscriptions[user];
        return block.timestamp < info.startTime + info.duration;
    }

    // Check if user has pay-per-view access
    function hasPayPerViewAccess(address user) public view returns (bool) {
        return payPerViewAccess[user];
    }
}
