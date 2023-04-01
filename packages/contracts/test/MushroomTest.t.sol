// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import { MudV2Test } from "@latticexyz/std-contracts/src/test/MudV2Test.t.sol";
import { IWorld } from "../src/world/IWorld.sol";
import { MushroomTable } from "../src/tables/MushroomTable.sol";

contract MushroomTest is MudV2Test {
  IWorld world;

  function setUp() public override {
    super.setUp();
    world = IWorld(worldAddress);
  }

  function testMushroom() public {
    address alice = address(1);
    vm.startPrank(alice);
    world.gnomik_mushroom_produce();
    int32 mushrooms = MushroomTable.get(world, alice);
    assertEq(mushrooms, 1);
    world.gnomik_mushroom_eat();
    mushrooms = MushroomTable.get(world, alice);
    assertEq(mushrooms, 0);
  }
}
