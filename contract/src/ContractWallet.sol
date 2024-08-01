//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Consumer {
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function deposit() public payable {}
}

contract ContractWallet {
    mapping(address => uint) public balance;
    mapping(address => uint) public registered_passwd_hash;
    mapping(bytes => bool) private used_proof;

    function _check_passwd(
        address sent_from,
        uint passwd_hash,
        bytes memory proof
    ) private returns (bool) {
        // todo verify zkp proof.

        return false;
    }

    function transfer(
        address payable send_to,
        uint amount,
        uint passwd_hash,
        bytes memory proof
    ) public {
        require(used_proof[proof], "This proof is already used.");
        require(
            _check_passwd(msg.sender, passwd_hash, proof),
            "Invalid proof."
        );
        require(balance[msg.sender] >= amount, "Not enough money");

        balance[msg.sender] -= amount;
        send_to.transfer(amount);
    }
}
