// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployRaffle} from "script/DeployRaffle.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {Raffle} from "src/Raffle.sol";

contract RaffleTest is Test {
    event RaffleEnter(address indexed player);
    event WinnerPicked(address indexed winner);

    Raffle public raffle;
    HelperConfig public helperConfig;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane;
    uint256 subscriptionId;
    uint32 callbackGasLimit;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        entranceFee = config.entranceFee;
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        gasLane = config.gasLane;
        callbackGasLimit = config.callbackGasLimit;
        subscriptionId = config.subscriptionId;

        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);
    }

    function testRaffleInitializeInOpenState() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    function testRaffleRevertsWhenYouDoNotPayEnough() public {
        // Arrange
        vm.prank(PLAYER); // It simulates the PLAYER address is calling the function
        // Act / Assert
        vm.expectRevert(Raffle.Raffle__SendMoreToEnterRaffle.selector);
        raffle.enterRaffle();
    }

    function testRaffleRecordsPlayersWhenTheyEnter() public {
        // Arrange
        vm.prank(PLAYER);
        // Act
        raffle.enterRaffle{value: entranceFee + callbackGasLimit}();
        // Assert
        vm.assertEq(raffle.getPlayers()[0], PLAYER);
    }

    function testEnteringRaffleEmitsEvent() public {
        // Arrange
        vm.prank(PLAYER);
        // Act & Assert
        vm.expectEmit(true, false, false, false, address(raffle));
        emit RaffleEnter(PLAYER);
        raffle.enterRaffle{value: entranceFee + callbackGasLimit}();
    }

    function testDontAllowPlayersToEnterWhileRaffleIsCalculating() public {
        // Arrange
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee + callbackGasLimit}();
        vm.warp(block.timestamp + interval + 1); // vm.warp() sets the block timestamp
        vm.roll(block.number + 1); // vm.roll() sets the block number
        raffle.performUpkeep("");
        // Act / Assert
        vm.expectRevert(Raffle.Raffle__RaffleNotOpen.selector);
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee + callbackGasLimit}();
    }
}
