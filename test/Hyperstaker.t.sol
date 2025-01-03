// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Hyperstaker} from "../src/Hyperstaker.sol";
import {MockERC20} from "./mocks/MockERC20.sol";
import {HypercertMinter} from "./hypercerts/HypercertMinter.sol";

contract HyperstakerTest is Test {
    Hyperstaker public hyperstaker;
    MockHypercertMinter public hypercertMinter;
    uint256 public baseHypercertId = 1 << 128;
    uint256 public fractionHypercertId = (1 << 128) + 1;
    MockERC20 public rewardToken = new MockERC20("Reward", "REW");

    function setUp() public {
        hypercertMinter = new MockHypercertMinter();
        hyperstaker = new Hyperstaker(address(hypercertMinter), baseHypercertId, address(this));
        hypercertMinter.setUnits(baseHypercertId, 100);
        hypercertMinter.setUnits(fractionHypercertId, 100);
    }

    function test_Constructor() public {
        assertEq(hyperstaker.baseHypercertId(), baseHypercertId);
        assertEq(hyperstaker.totalUnits(), 100);
    }

    function test_Staking() public {
        hyperstaker.stake(fractionHypercertId);
        assertEq(hyperstaker.getStake(fractionHypercertId).stakingStartTime, block.timestamp);
    }

    function test_Unstaking() public {
        hyperstaker.stake(fractionHypercertId);
        hyperstaker.unstake(fractionHypercertId);
        assertEq(hyperstaker.getStake(fractionHypercertId).stakingStartTime, 0);
    }

    function test_SetReward() public {
        hyperstaker.setReward(address(0), 100);
        assertEq(hyperstaker.totalRewards(), 100);
    }
}
