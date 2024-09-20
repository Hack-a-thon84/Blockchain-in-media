// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Verification is Ownable {
    IERC20 public mediaToken; // ERC20 Token for rewarding verifiers
    uint256 public rewardAmount = 10 * (10 ** 18); // Reward for each verification

    struct VerificationReport {
        address verifier;
        bool isAuthentic; // True if verified as authentic
        uint256 stake; // Stake in tokens for the report
        bool claimed; // Whether the reward is claimed or not
    }

    struct ContentVerification {
        uint256 contentId;
        uint256 authenticityVotes;
        uint256 fraudVotes;
        mapping(address => VerificationReport) reports;
    }

    mapping(uint256 => ContentVerification) public contentVerifications;

    event ContentVerified(uint256 indexed contentId, address verifier, bool isAuthentic);
    event RewardClaimed(address verifier, uint256 amount);

    constructor(IERC20 _mediaToken) {
        mediaToken = _mediaToken;
    }

    // Submit verification report for content
    function verifyContent(uint256 _contentId, bool _isAuthentic, uint256 _stake) public {
        require(_stake > 0, "Stake must be greater than zero");
        require(mediaToken.balanceOf(msg.sender) >= _stake, "Insufficient token balance");

        ContentVerification storage verification = contentVerifications[_contentId];

        // Store verification report
        verification.reports[msg.sender] = VerificationReport(msg.sender, _isAuthentic, _stake, false);

        // Update vote counts
        if (_isAuthentic) {
            verification.authenticityVotes += _stake;
        } else {
            verification.fraudVotes += _stake;
        }

        emit ContentVerified(_contentId, msg.sender, _isAuthentic);
    }

    // Calculate consensus for content authenticity
    function getContentConsensus(uint256 _contentId) public view returns (string memory) {
        ContentVerification storage verification = contentVerifications[_contentId];
        if (verification.authenticityVotes > verification.fraudVotes) {
            return "Authentic";
        } else {
            return "Fraudulent";
        }
    }

    // Reward verifiers based on consensus
    function claimReward(uint256 _contentId) public {
        ContentVerification storage verification = contentVerifications[_contentId];
        VerificationReport storage report = verification.reports[msg.sender];

        require(!report.claimed, "Reward already claimed");
        require(report.verifier == msg.sender, "Only the verifier can claim the reward");

        string memory consensus = getContentConsensus(_contentId);
        if ((keccak256(abi.encodePacked(consensus)) == keccak256(abi.encodePacked("Authentic")) && report.isAuthentic) ||
            (keccak256(abi.encodePacked(consensus)) == keccak256(abi.encodePacked("Fraudulent")) && !report.isAuthentic)) {
            
            mediaToken.transfer(msg.sender, report.stake + rewardAmount);
        } else {
            mediaToken.transfer(owner(), report.stake); // Penalize the verifier
        }

        report.claimed = true;
        emit RewardClaimed(msg.sender, report.stake + rewardAmount);
    }

    // Set reward amount for verifications
    function setRewardAmount(uint256 _rewardAmount) public onlyOwner {
        rewardAmount = _rewardAmount;
    }
}