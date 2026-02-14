// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Identity {

    struct Credential {
        bytes32 credentialHash;
        string ipfsCID;
        address issuer;
        bool isValid;
        uint256 issuedAt;
    }

    address public owner;

    mapping(address => bool) public guardians;
    uint256 public guardianCount;
    uint256 public recoveryThreshold;

    Credential[] public credentials;

    // Recovery voting
    address public proposedOwner;
    mapping(address => bool) public guardianVotes;
    uint256 public voteCount;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyGuardian() {
        require(guardians[msg.sender], "Not guardian");
        _;
    }

    constructor(address _owner, address[] memory _guardians, uint256 _threshold) {
        owner = _owner;

        for (uint i = 0; i < _guardians.length; i++) {
            guardians[_guardians[i]] = true;
        }

        guardianCount = _guardians.length;
        recoveryThreshold = _threshold;
    }

    // ---------------- Credential Storage ----------------

    function addCredential(
        bytes32 _hash,
        string memory _cid,
        address _issuer
    ) external onlyOwner {
        credentials.push(
            Credential(_hash, _cid, _issuer, true, block.timestamp)
        );
    }

    function getCredentials() external view returns (Credential[] memory) {
        return credentials;
    }

    // ---------------- Recovery Logic ----------------

    function proposeRecovery(address _newOwner) external onlyGuardian {
        proposedOwner = _newOwner;
        voteCount = 0;
    }

    function voteRecovery() external onlyGuardian {
        require(proposedOwner != address(0), "No proposal");
        require(!guardianVotes[msg.sender], "Already voted");

        guardianVotes[msg.sender] = true;
        voteCount++;

        if (voteCount >= recoveryThreshold) {
            owner = proposedOwner;
            proposedOwner = address(0);
            voteCount = 0;
        }
    }
}
