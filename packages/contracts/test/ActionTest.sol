// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import { MudV2Test } from "@latticexyz/std-contracts/src/test/MudV2Test.t.sol";
import { IWorld } from "../src/world/IWorld.sol";
import { ResourceTable } from "../src/tables/ResourceTable.sol";

contract ActionTest is MudV2Test {
  IWorld world;

  function setUp() public override {
    super.setUp();
    world = IWorld(worldAddress);
  }

  function testAction() public {
    address alice = address(1);
    vm.startPrank(alice);
    world.gnomik_action_callAction(bytes32(abi.encodePacked("gather")), alice);
    int256 mushrooms = ResourceTable.getValue(world, bytes32(abi.encodePacked("mushroom")), alice);
    assertEq(mushrooms, 1);
    world.gnomik_action_callAction(bytes32(abi.encodePacked("gather")), alice);
    world.gnomik_action_callAction(bytes32(abi.encodePacked("gather")), alice);
    world.gnomik_action_callAction(bytes32(abi.encodePacked("gather")), alice);
    world.gnomik_action_callAction(bytes32(abi.encodePacked("gather")), alice);
    world.gnomik_action_callAction(bytes32(abi.encodePacked("gather")), alice);
    world.gnomik_action_callAction(bytes32(abi.encodePacked("gather")), alice);
    world.gnomik_action_callAction(bytes32(abi.encodePacked("gather")), alice);
    world.gnomik_action_callAction(bytes32(abi.encodePacked("gather")), alice);
    world.gnomik_action_callAction(bytes32(abi.encodePacked("gather")), alice);
    mushrooms = ResourceTable.getValue(world, bytes32(abi.encodePacked("mushroom")), alice);
    assertEq(mushrooms, 10);
    world.gnomik_action_callAction(bytes32(abi.encodePacked("eat")), alice);
    int256 mushrooms2 = ResourceTable.getValue(world, bytes32(abi.encodePacked("mushroom")), alice);
    int256 rate = ResourceTable.getRate(world, bytes32(abi.encodePacked("mushroom")), alice);
    console.log('LOG');
    console.logInt(rate);
    console.logInt(mushrooms2);
  }

}
