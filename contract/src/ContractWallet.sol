//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface PlonkVerifierInterface {
    function verifyProof(
        uint256[24] calldata _proof,
        uint256[2] calldata _pubSignals
    ) external view returns (bool);
}

contract ContractWallet {
    PlonkVerifierInterface verifierContract;
    constructor(address verifierContractAddress) {
        verifierContract = PlonkVerifierInterface(verifierContractAddress);
    }

    mapping(address => uint) public balance;
    mapping(address => uint) public registered_passwd_hash;
    mapping(bytes => bool) private used_proof;

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        balance[msg.sender] += msg.value;
    }

    function getTotalBalance() public view returns (uint) {
        return address(this).balance;
    }

    function transfer(
        address payable send_to,
        uint amount,
        uint256[24] calldata _proof,
        uint256[2] calldata _pubSignals
    ) public {
        // require(used_proof[proof], "This proof is already used.");

        address from = address(uint160(_pubSignals[1]));
        require(msg.sender == from, "You are not prover.");
        bool validProof = verifierContract.verifyProof(_proof, _pubSignals);
        require(validProof, "Invalid proof.");
        require(balance[msg.sender] >= amount, "Not enough money");

        balance[msg.sender] -= amount;
        send_to.transfer(amount);
    }

    function testmethod() public pure returns (uint) {
        return 12345;
    }
}
