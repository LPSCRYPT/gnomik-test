// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Script.sol";
import { IWorld } from "../src/world/IWorld.sol";
import { ActionTable } from "../src/tables/ActionTable.sol";

contract PostDeploy is Script {

  string[] names = ["eat","think"];
  int[] cost1 = [int(10),100];
  int[] cost2 = [int(0),0];
  bool[] target = [true, true];
  int[] resultAmount = [int(1),1];
  string[] costResource1 = ["mushroom","mushroom"];
  string[] costResource2 = ["",""];
  string[] costFunction = ["sub","sub"];
  string[] resultResource = ["mushroom","thought"];
  string[] resultFunction = ["add","add"];
  string[] resultType = ["rate","resource"]; 

  function run(address worldAddress) external {
    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);
    // create gather function
    ActionTable.set(IWorld(worldAddress), bytes32(abi.encodePacked("gather")), 0, 0, true, 1, 'mushroom', '', 'add',  "mushroom", "add", "resource");

    ActionTable.set(IWorld(worldAddress), 
    bytes32(abi.encodePacked("eat")), 
    10, 
    0, 
    true, 
    1, 
    "mushroom", 
    "", 
    "sub", 
    "mushroom", 
    "add", 
    "rate");

    // for (uint i = 0; i > names.length; i++) {
    //   ActionTable.set(IWorld(worldAddress), 
    //   bytes32(abi.encodePacked(names[i])), 
    //   cost1[i], 
    //   cost2[i], 
    //   target[i], 
    //   resultAmount[i], 
    //   costResource1[i], 
    //   costResource2[i], 
    //   costFunction[i], 
    //   resultResource[i], 
    //   resultFunction[i], 
    //   resultType[i]);
    // }
    // ActionTable.set(IWorld(worldAddress), 
    //   bytes32(abi.encodePacked(names[0])), 
    //   cost1[0], 
    //   cost2[0], 
    //   target[0], 
    //   resultAmount[0], 
    //   costResource1[0], 
    //   costResource2[0], 
    //   costFunction[0], 
    //   resultResource[0], 
    //   resultFunction[0], 
    //   resultType[0]);

    vm.stopBroadcast();
  }
}
