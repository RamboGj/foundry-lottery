// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
  * @title Raffle 
  * @author Artemis 
  * @notice This contract is for creating a sample raffle 
  * @dev Implements Chainlink VRFv2.5
*/
contract Raffle {
  /* Errors */
  error Raffle__SendMoreToEnterRaffle();

  uint256 private immutable i_entranceFee;
  address payable[] private s_players;

  /* Events */
  event RaffleEnter(address indexed player);

  constructor(uint256 entranceFee) {
    i_entranceFee = entranceFee;
  }

  function enterReffle() public payable {
    // require(msg.value >= i_entranceFee, "Not enough ETH sent!");
    // require(msg.value >= i_entranceFee, SendMoreToEnterRaffle());
    if (msg.value <= i_entranceFee) {
      revert Raffle__SendMoreToEnterRaffle();
    }
    s_players.push(payable(msg.sender));
    // 1 -> (emit event) Makes migrations easier
    // 2 -> (emit event) Makes frontend indexing easier
    emit RaffleEnter(msg.sender);
  }

  function pickWinner() public {}

  /* Getter functions */
  function getEntranceFee() external view returns(uint256) {
    return i_entranceFee;
  }
}
