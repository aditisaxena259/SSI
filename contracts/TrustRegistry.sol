// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NeuralHashTrustRegistry {

    address public owner;

    struct Issuer {
        string name;          // Human-readable name
        string metadataURI;   // Optional IPFS link with more details
        bool isTrusted;       // Trust status
        uint256 addedAt;      // Timestamp
    }

    mapping(address => Issuer) private issuers;

    event IssuerUpdated(
        address indexed issuer,
        string name,
        string metadataURI,
        bool isTrusted
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Add or update issuer trust status
    function setIssuer(
        address _issuer,
        string calldata _name,
        string calldata _metadataURI,
        bool _isTrusted
    ) external onlyOwner {

        issuers[_issuer] = Issuer({
            name: _name,
            metadataURI: _metadataURI,
            isTrusted: _isTrusted,
            addedAt: block.timestamp
        });

        emit IssuerUpdated(
            _issuer,
            _name,
            _metadataURI,
            _isTrusted
        );
    }

    // Check if issuer is trusted
    function isTrusted(address _issuer)
        external
        view
        returns (bool)
    {
        return issuers[_issuer].isTrusted;
    }

    // Get full issuer details
    function getIssuer(address _issuer)
        external
        view
        returns (
            string memory name,
            string memory metadataURI,
            bool trusted,
            uint256 addedAt
        )
    {
        Issuer memory issuer = issuers[_issuer];

        return (
            issuer.name,
            issuer.metadataURI,
            issuer.isTrusted,
            issuer.addedAt
        );
    }

    // Optional: Transfer ownership
    function transferOwnership(address newOwner)
        external
        onlyOwner
    {
        require(newOwner != address(0), "Zero address");
        owner = newOwner;
    }
}
