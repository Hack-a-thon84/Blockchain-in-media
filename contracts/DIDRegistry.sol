// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DIDRegistry {
    struct Identity {
        address owner;
        string did; // Decentralized Identifier
        bool verified;
    }

    mapping(address => Identity) public identities;

    event IdentityRegistered(address indexed owner, string did);
    event IdentityVerified(address indexed owner, string did);

    // Register a new DID for the sender
    function registerIdentity(string memory _did) public {
        require(bytes(_did).length > 0, "DID cannot be empty");
        identities[msg.sender] = Identity(msg.sender, _did, false);
        emit IdentityRegistered(msg.sender, _did);
    }

    // Verify the identity (done off-chain and updated here)
    function verifyIdentity(address _owner) public {
        require(identities[_owner].owner != address(0), "Identity not registered");
        identities[_owner].verified = true;
        emit IdentityVerified(_owner, identities[_owner].did);
    }

    // Get identity details
    function getIdentity(address _owner) public view returns (string memory, bool) {
        Identity memory identity = identities[_owner];
        return (identity.did, identity.verified);
    }
}
