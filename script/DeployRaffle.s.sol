// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";

contract DeployRaffle is Script {
  function run() external returns(Raffle) {
    uint256 entranceFee = 0.1 ether;

    vm.startBroadcast();
    Raffle raffle = new Raffle(entranceFee);
    vm.stopBroadcast();
    return raffle;
  }
}