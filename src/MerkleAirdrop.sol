// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MerkleAirdrop {
    // some list of addresses
    // Allow someone in the list to claim tokens
    address[] claimers;

    // ALERT: This function will cause a massive gas amount to interact with and DoS
    // function claim(address account) external {
    //     for (i = 0; i < claimers.length; i++) {
    //         // check the account link is in the claimers array
    //     }
    // }

    // Merkle Proofs - cryptographic technique allows for efficient verification of data inclusion without storing the entire dataset on-chain.
}
