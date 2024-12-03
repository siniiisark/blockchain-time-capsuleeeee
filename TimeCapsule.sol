// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeCapsule {
    struct Capsule {
        address creator;
        string message;
        uint256 unlockTime;
    }

    // Mapping from a unique capsule ID to the capsule
    mapping(string => Capsule) private capsules;

    // Event to notify when a capsule is created
    event CapsuleCreated(string id, address indexed creator, uint256 unlockTime);
    
    // Event to notify when a capsule is viewed
    event CapsuleViewed(string id, string message);

    // Function to create a time capsule
    function createCapsule(
        string memory _id,
        string memory _message,
        uint256 _unlockTime
    ) external {
        require(_unlockTime > block.timestamp, "Unlock time must be in the future");
        require(bytes(capsules[_id].message).length == 0, "Capsule ID already exists");

        capsules[_id] = Capsule({
            creator: msg.sender,
            message: _message,
            unlockTime: _unlockTime
        });

        emit CapsuleCreated(_id, msg.sender, _unlockTime);
    }

    // Function to view a time capsule
    function viewCapsule(string memory _id) external view returns (string memory) {
        Capsule memory capsule = capsules[_id];

        require(bytes(capsule.message).length != 0, "Capsule does not exist");
        require(block.timestamp >= capsule.unlockTime, "Capsule is locked");

        return capsule.message;
    }

    // Function to check if a capsule is ready to be viewed
    function isCapsuleReady(string memory _id) external view returns (bool) {
        Capsule memory capsule = capsules[_id];
        if (bytes(capsule.message).length == 0) {
            return false; // Capsule does not exist
        }
        return block.timestamp >= capsule.unlockTime;
    }
}
