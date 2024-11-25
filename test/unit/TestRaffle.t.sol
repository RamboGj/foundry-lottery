// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Test, console} from "forge-std/Test.sol";
import {Raffle} from "../src/Raffle.sol";
import {DeployRaffle} from "../script/DeployRaffle.s.sol";

contract TestRaffle is Script {
  Raffle raffle;

  function setUp() external {
    DeployRaffle deployRaffle = new DeployRaffle();
    raffle = deployRaffle.run();
  }

  function testEntranceFeeIsCorrect() external {
    uint256 entranceFee = raffle.getEntranceFee();

    assertEq(entranceFee, 0.1 ether);
  }
}