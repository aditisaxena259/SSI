// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NeuralHashSSI {

    struct Credential {
        bytes32 credentialHash;
        string ipfsCID;
        address issuer;
        bool isValid;
        uint256 issuedAt;
    }

    mapping(address => Credential[]) private userCredentials;
    mapping(bytes32 => bool) private issuedHashes;

    event CredentialIssued(
        address indexed user,
        bytes32 indexed credentialHash,
        string ipfsCID,
        address indexed issuer
    );

    event CredentialRevoked(
        address indexed user,
        bytes32 indexed credentialHash
    );

    function issueCredential(
        address user,
        bytes32 credentialHash,
        string calldata ipfsCID
    ) external {
        require(!issuedHashes[credentialHash], "Already issued");

        userCredentials[user].push(
            Credential({
                credentialHash: credentialHash,
                ipfsCID: ipfsCID,
                issuer: msg.sender,
                isValid: true,
                issuedAt: block.timestamp
            })
        );

        issuedHashes[credentialHash] = true;

        emit CredentialIssued(user, credentialHash, ipfsCID, msg.sender);
    }

    function verifyCredential(
        address user,
        bytes32 credentialHash
    ) external view returns (bool) {
        Credential[] memory creds = userCredentials[user];

        for (uint i = 0; i < creds.length; i++) {
            if (
                creds[i].credentialHash == credentialHash &&
                creds[i].isValid
            ) {
                return true;
            }
        }
        return false;
    }

    function getUserCredentials(address user)
        external
        view
        returns (Credential[] memory)
    {
        return userCredentials[user];
    }

    function revokeCredential(
        address user,
        bytes32 credentialHash
    ) external {
        Credential[] storage creds = userCredentials[user];

        for (uint i = 0; i < creds.length; i++) {
            if (creds[i].credentialHash == credentialHash) {
                require(
                    msg.sender == creds[i].issuer,
                    "Only issuer"
                );
                creds[i].isValid = false;
                emit CredentialRevoked(user, credentialHash);
                return;
            }
        }

        revert("Not found");
    }
}
