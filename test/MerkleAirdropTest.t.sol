// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {BagelToken} from "../src/BagelToken.sol";

contract MerkleAirdropTest is Test {
    MerkleAirdrop public airdrop;
    BagelToken public token;

    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 public AMOUNT_TO_CLAIM = 25 * 1e18;
    uint256 public AMOUNT_TO_SEND = AMOUNT_TO_CLAIM * 4;
    bytes32 proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public PROOF = [proofOne, proofTwo]; // from output which locating the manually added user address which ends with ...9129D
    address user;
    uint256 userPrivateKey;

    function setUp() public {
        token = new BagelToken();
        airdrop = new MerkleAirdrop(ROOT, token);
        // by adding the whitelist index 0 a generated address, we now can test it as it has already added in airdrop list
        token.mint(token.owner(), AMOUNT_TO_SEND);
        token.transfer(address(airdrop), AMOUNT_TO_SEND); // transfering all the amount of tokens to airdrop to send them to addresses
        (user, userPrivateKey) = makeAddrAndKey("user");
    }

    function testUsersCanClaim() public {
        uint256 startingBalance = token.balanceOf(user);

        vm.prank(user); // only pranks the 1 line below
        airdrop.claim(user, AMOUNT_TO_CLAIM, PROOF);

        uint256 endingBalance = token.balanceOf(user);
        console.log("Ending balance is:", endingBalance);
        assertEq(endingBalance - startingBalance, AMOUNT_TO_CLAIM);

        // console.log("user address:", user);
        // this will be firstly used to generate the user address and adding them to scripts of generating the merkle tree input and outputs to addin the function whitelist array index 0 to test the contract
        // to make it happen, open the terminal and run "forge test -vv" when this console log is active and that will be the test contract that should be
        // implemented manually as 0 index's contract address to test! In our scenario, it is
        // 0x6CA6d1e2D5347Bfab1d91e883F1915560e09129D this and it has already added to GenerateInput.s.sol script
        // to furtherly test properly the input and output and even generate input script.
        // Remember to forge script script/ those generateinput.s.sol and makemerkle.s.sol again to implement that contract
        // so the output and input can be tested
        // you can check if that contract is available as 0th index in output and input.json files.
    }
}
