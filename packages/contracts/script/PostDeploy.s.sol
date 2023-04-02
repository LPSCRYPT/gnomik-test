// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Script.sol";
import { IWorld } from "../src/world/IWorld.sol";
import { ActionTable } from "../src/tables/ActionTable.sol";

contract PostDeploy is Script {
  function run(address worldAddress) external {
    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);
    // create gather function
    ActionTable.set(IWorld(worldAddress), bytes32(abi.encodePacked("gather")), 0, 0, true, 1, 'mushroom', '', 'add',  "mushroom", "add", "resource");
    vm.stopBroadcast();
  }
}
