// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "./../src/ContractWallet.sol";

contract Deployment is Script {
    function run() external {
        // uint256(vm.envBytes32(envKey));
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ContractWallet w = new ContractWallet();

        vm.stopBroadcast();

        
        bytes memory encodedData = abi.encodePacked("CONTRACT_WALLET_ADDR=", vm.toString(address(w)));
        vm.writeLine(
            string(
                abi.encodePacked(vm.projectRoot(), "/.env")
            ),
            string(encodedData)
        );
    }
}