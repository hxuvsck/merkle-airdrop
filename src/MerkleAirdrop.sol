// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    error MerkleAirdrop__InvalidProof();

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

    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_aridropToken;

    event Claim(address account, uint256 amount);

    constructor(bytes32 merkleRoot, IERC20 airdropToken) {
        i_merkleRoot = merkleRoot;
        i_aridropToken = airdropToken;
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        // Calculate using the accound and the amount, the hash -> leaf node
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        // we encoded the numbers together by keccak256 hashing algorithm and making the leaf node (mashed and hashed acc and amount together)
        // Also by doing keccak256 hashing again with bytes concatonate is for second pre-image attack to the account and amount first time hashing could face some collisions.

        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }
        emit Claim(account, amount);
        i_aridropToken.transfer(account, amount);
    }
}
