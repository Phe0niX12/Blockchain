// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VoterRegistration {
    struct Voter {
        bool voted;
        uint candidateId;
        bool isRegistered;
    }

    mapping(address => Voter) public voters;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerVoter(address _voter) public onlyOwner {
        voters[_voter].isRegistered = true;
    }

    function isRegistered(address _voter) public view returns (bool) {
        return voters[_voter].isRegistered;
    }

    function hasVoted(address _voter) public view returns (bool) {
        return voters[_voter].voted;
    }

    function recordVote(address _voter, uint _candidateId) public {
        require(voters[_voter].isRegistered, "Voter is not registered");
        require(!voters[_voter].voted, "Voter has already voted");

        voters[_voter].voted = true;
        voters[_voter].candidateId = _candidateId;
    }
}
