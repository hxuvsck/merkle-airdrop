// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol"; // changing to utils of erc20 contract's SafeERC20 instead of IERC20 because this SafeERC20 contract is also included IERC20.
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    using SafeERC20 for IERC20;

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();

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

    mapping(address claimer => bool claimed) private s_hasClaimed;

    event Claim(address account, uint256 amount);

    constructor(bytes32 merkleRoot, IERC20 airdropToken) {
        i_merkleRoot = merkleRoot;
        i_aridropToken = airdropToken;
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        if (s_hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed(); // now we preventing people from multiple claims!
        }
        // Calculate using the accound and the amount, the hash -> leaf node
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        // we encoded the numbers together by keccak256 hashing algorithm and making the leaf node (mashed and hashed acc and amount together)
        // Also by doing keccak256 hashing again with bytes concatonate is for second pre-image attack to the account and amount first time hashing could face some collisions.

        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }
        s_hasClaimed[account] = true;

        emit Claim(account, amount);
        i_aridropToken.safeTransfer(account, amount);
        // What if the address is unable to receive ERC20 token? Then the SafeERC20 comes in place.

        // A problem here facing now is when the address is in a merkle tree, but claiming clicking is far more than one and drain the fund?
        // We need to keep the mapping of who/what address has already claimed the drop. That's why we will be doing the mapping of address above.

        // s_hasClaimed[account] = true; // it is vulnerable to reentrancy attack. So it needs to be above the emit function and CEI based if claimed or not must be the first most checked in this function.
    }

    //////////////////////////
    //// Getter Functions ////
    //////////////////////////

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (IERC20) {
        return i_aridropToken;
        // See what the airdrop token address is.
    }
}
