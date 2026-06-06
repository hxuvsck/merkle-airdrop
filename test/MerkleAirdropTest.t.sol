// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {BagelToken} from "../src/BagelToken.sol";

contract MerkleAirdropTest is Test {
    MerkleAirdrop public airdrop;
    BagelToken public token;

    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    address user;
    uint256 userPrivateKey;

    function setUp() public {
        token = new BagelToken();
        airdrop = new MerkleAirdrop(ROOT, token);
        // by adding the whitelist index 0 a generated address, we now can test it as it has already added in airdrop list
        (user, userPrivateKey) = makeAddrAndKey("user");
    }

    function testUsersCanClaim() public {
        // console.log("user address:", user); // this will be firstly used to generate the user address and adding them to scripts of generating the merkle tree input and outputs to addin the function whitelist array index 0 to test the contract
    }
}
