const VoterRegistration = artifacts.require("VoterRegistration");
const CandidateVoting = artifacts.require("CandidateVoting");

module.exports = async function (deployer) {
    await deployer.deploy(VoterRegistration);
    const voterRegistration = await VoterRegistration.deployed();
    await deployer.deploy(CandidateVoting, voterRegistration.address);
};