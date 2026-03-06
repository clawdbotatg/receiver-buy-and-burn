// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SwapAndBurn.sol";

/// @notice Deploys SwapAndBurn via Nick's CREATE2 factory to get a deterministic address.
///         Same salt + same bytecode = 0x00C1a3Dc05E696B5674efb8C7DFfad333ea16d7d on ANY chain.
///
/// Nick's factory: 0x4e59b44847b379578588920cA78FbF26c0B4956C
/// Salt:           0x9a7ef257572e3aed4d9f06081ed3cc9f2dd9ce750e2e6744b25a63f3a9d8d74d
/// Expected addr:  0x00C1a3Dc05E696B5674efb8C7DFfad333ea16d7d
contract Deploy is Script {
    address constant NICK_FACTORY = 0x4e59b44847b379578588920cA78FbF26c0B4956C;
    bytes32 constant SALT = 0x9a7ef257572e3aed4d9f06081ed3cc9f2dd9ce750e2e6744b25a63f3a9d8d74d;
    address constant EXPECTED = 0x00C1a3Dc05E696B5674efb8C7DFfad333ea16d7d;

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
