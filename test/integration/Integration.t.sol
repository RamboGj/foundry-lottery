// unit
// integration
// forked
// staging

// fuzzing
// stateful fuzz
// stateless fuzz
// formal verification
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Raffle} from "src/Raffle.sol";
import {DeployRaffle} from "script/DeployRaffle.s.sol";

contract InteractionsTest is Test {
    Raffle raffle;
    address PLAYER = makeAddr("player");

    function setUp() external {
        DeployRaffle deployRaffle = new DeployRaffle();
        raffle = deployRaffle.run();
        vm.deal(PLAYER, 1 ether);
    }

    function testPlayerCanJoinRaffle() external {
        // todo
    }
}
