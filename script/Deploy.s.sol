// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SwapAndBurn.sol";

/// @notice Deploys SwapAndBurn via Nick's CREATE2 factory to get a deterministic address.
///         Same salt + same bytecode = 0x0C1a3DB07304D2E4E551AB4A7b083382a33f25ad on ANY chain.
///         Address reads: 0x0-C1a3D-B07 = "clawd-bot"
///
/// Nick's factory: 0x4e59b44847b379578588920cA78FbF26c0B4956C
/// Salt:           0x0786cbac0aebf290c1bba11357282c8a7ae6f3e6c83c97e753cc73bc17115007
/// Expected addr:  0x0C1a3DB07304D2E4E551AB4A7b083382a33f25ad
contract Deploy is Script {
    address constant NICK_FACTORY = 0x4e59b44847b379578588920cA78FbF26c0B4956C;
    bytes32 constant SALT = 0x0786cbac0aebf290c1bba11357282c8a7ae6f3e6c83c97e753cc73bc17115007;
    address constant EXPECTED = 0x0C1a3DB07304D2E4E551AB4A7b083382a33f25ad;

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
