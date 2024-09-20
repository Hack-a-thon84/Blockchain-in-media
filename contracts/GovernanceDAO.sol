// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GovernanceDAO {
    IERC20 public governanceToken; // Governance token (e.g., MEDIA token)
    uint256 public proposalCount;  // Counter for proposal IDs
    uint256 public votingPeriod = 7 days; // Voting period duration

    struct Proposal {
        uint256 id;
        string description;
        address proposer;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 endTime;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted; // Track if user voted on a proposal

    event ProposalCreated(uint256 id, string description, address proposer);
    event Voted(uint256 id, address voter, bool voteFor);
    event ProposalExecuted(uint256 id);

    constructor(IERC20 _governanceToken) {
        governanceToken = _governanceToken;
    }

    // Create a new proposal for governance
    function createProposal(string memory _description) public {
        proposalCount += 1;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: _description,
            proposer: msg.sender,
            votesFor: 0,
            votesAgainst: 0,
            endTime: block.timestamp + votingPeriod,
            executed: false
        });

        emit ProposalCreated(proposalCount, _description, msg.sender);
    }

    // Vote on a proposal (true = vote for, false = vote against)
    function vote(uint256 _proposalId, bool _voteFor) public {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp < proposal.endTime, "Voting has ended");
        require(!hasVoted[_proposalId][msg.sender], "Already voted");

        uint256 voterBalance = governanceToken.balanceOf(msg.sender);
        require(voterBalance > 0, "No governance tokens to vote");

        if (_voteFor) {
            proposal.votesFor += voterBalance;
        } else {
            proposal.votesAgainst += voterBalance;
        }

        hasVoted[_proposalId][msg.sender] = true;
        emit Voted(_proposalId, msg.sender, _voteFor);
    }

    // Execute the proposal if voting period has ended and it passed
    function executeProposal(uint256 _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.endTime, "Voting period has not ended");
        require(!proposal.executed, "Proposal already executed");
        require(proposal.votesFor > proposal.votesAgainst, "Proposal did not pass");

        proposal.executed = true;
        // Logic for proposal execution, like updating platform settings
        emit ProposalExecuted(_proposalId);
    }

    // Change the voting period
    function setVotingPeriod(uint256 _newPeriod) public {
        require(_newPeriod >= 1 days && _newPeriod <= 30 days, "Invalid voting period");
        votingPeriod = _newPeriod;
    }
}
