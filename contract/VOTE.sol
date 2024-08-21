// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // Store candidates
    mapping(uint => Candidate) public candidates;
    // Track the number of candidates
    uint public candidatesCount;
    // Store votes
    mapping(address => bool) public voters;

    // Define the owner of the contract
    address public owner;

    // Define an event to be emitted when a vote is cast
    event VoteCasted(uint candidateId, address voter);

    // Modifier to restrict function access to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    // Constructor to initialize the contract with candidates (optional)
    constructor(string[] memory candidateNames) {
        owner = msg.sender;
        for (uint i = 0; i < candidateNames.length; i++) {
            addCandidate(candidateNames[i]);
        }
    }

    // Add a candidate (can only be called by the owner)
    function addCandidate(string memory _name) public onlyOwner {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    // Vote for a candidate
    function vote(uint _candidateId) public {
        require(!voters[msg.sender], "You have already voted.");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        emit VoteCasted(_candidateId, msg.sender);
    }

    // Get the vote count of a candidate
    function getVoteCount(uint _candidateId) public view returns (uint) {
        return candidates[_candidateId].voteCount;
    }

    // Function to get all candidates' names
    function getCandidates() public view returns (string[] memory) {
        string[] memory names = new string[](candidatesCount);
        for (uint i = 1; i <= candidatesCount; i++) {
            names[i - 1] = candidates[i].name;
        }
        return names;
    }
}