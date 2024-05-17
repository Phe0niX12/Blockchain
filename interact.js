const Web3 = require('web3');
const contract = require('@truffle/contract');

// Import the contract artifacts
const VoterRegistrationArtifact = require('./build/contracts/VoterRegistration.json');
const CandidateVotingArtifact = require('./build/contracts/CandidateVoting.json');

// Setup Web3
const web3 = new Web3('http://127.0.0.1:8545');

// Setup contract instances
const VoterRegistration = contract(VoterRegistrationArtifact);
const CandidateVoting = contract(CandidateVotingArtifact);

VoterRegistration.setProvider(web3.currentProvider);
CandidateVoting.setProvider(web3.currentProvider);

const interact = async () => {
    try {
        // Get the accounts
        const accounts = await web3.eth.getAccounts();

        // Get the deployed contract instances
        const voterRegistration = await VoterRegistration.deployed();
        const candidateVoting = await CandidateVoting.deployed();

        // Register a voter
        await voterRegistration.registerVoter(accounts[0], { from: accounts[0] });
        console.log("Voter registered.");

        // Add a candidate
        await candidateVoting.addCandidate("Alice", { from: accounts[0] });
        console.log("Candidate Alice added.");

        // Vote for a candidate
        await candidateVoting.vote(1, { from: accounts[0] });
        console.log("Vote casted.");

        // Get the results
        const results = await candidateVoting.getResults();

        // Print the results
        results.forEach(candidate => {
            console.log(`Candidate ${candidate.id}: ${candidate.name} has ${candidate.voteCount} votes`);
        });
    } catch (error) {
        console.error("Error interacting with the contract:", error);
    }
};

interact();
