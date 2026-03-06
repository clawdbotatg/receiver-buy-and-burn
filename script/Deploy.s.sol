// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SwapAndBurn.sol";

/// @notice Deploys SwapAndBurn via Nick's CREATE2 factory to get a deterministic address.
///         Same salt + same bytecode = 0xC1a3dcb24C53DA3E5FB22679017EB64724B43b6B on ANY chain.
///
/// Nick's factory: 0x4e59b44847b379578588920cA78FbF26c0B4956C
/// Salt:           0x2f4a4260ea07113cc669b376153c9b384be74f06f1f99b8b49987705473672c7
/// Expected addr:  0xC1a3dcb24C53DA3E5FB22679017EB64724B43b6B
contract Deploy is Script {
    address constant NICK_FACTORY = 0x4e59b44847b379578588920cA78FbF26c0B4956C;
    bytes32 constant SALT = 0x2f4a4260ea07113cc669b376153c9b384be74f06f1f99b8b49987705473672c7;
    address constant EXPECTED = 0xC1a3dcb24C53DA3E5FB22679017EB64724B43b6B;

    function run() external {
        vm.startBroadcast();

        bytes memory initCode = type(SwapAndBurn).creationCode;

        // Nick's factory: first 32 bytes = salt, rest = initCode
        (bool success,) = NICK_FACTORY.call(abi.encodePacked(SALT, initCode));
        require(success, "Deploy failed");

        require(
            address(uint160(uint256(keccak256(abi.encodePacked(
                bytes1(0xff),
                NICK_FACTORY,
                SALT,
                keccak256(initCode)
            ))))) == EXPECTED,
            "Address mismatch"
        );

        vm.stopBroadcast();

        console.log("SwapAndBurn deployed at:", EXPECTED);
        console.log("Verify: https://basescan.org/address/", EXPECTED);
    }
}
