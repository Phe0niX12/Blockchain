// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./VoterRegistration.sol";

contract CandidateVoting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;
    address public owner;
    VoterRegistration public voterRegistration;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    event ElectionResult(uint candidateId, string candidateName, uint voteCount);

    constructor(address _voterRegistration) {
        owner = msg.sender;
        voterRegistration = VoterRegistration(_voterRegistration);
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint _candidateId) public {
        require(voterRegistration.isRegistered(msg.sender), "You are not registered to vote");
        require(!voterRegistration.hasVoted(msg.sender), "You have already voted");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate");

        voterRegistration.recordVote(msg.sender, _candidateId);
        candidates[_candidateId].voteCount++;

        emit ElectionResult(_candidateId, candidates[_candidateId].name, candidates[_candidateId].voteCount);
    }

    function getResults() public view returns (Candidate[] memory) {
        Candidate[] memory results = new Candidate[](candidatesCount);
        for (uint i = 1; i <= candidatesCount; i++) {
            results[i-1] = candidates[i];
        }
        return results;
    }
}
