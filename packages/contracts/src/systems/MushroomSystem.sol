pragma solidity >=0.8.0;
import { System } from "@latticexyz/world/src/System.sol";
import { MushroomTable } from "../tables/MushroomTable.sol";

contract MushroomSystem is System {
    function produce() public {
        address sender = _msgSender();
        int32 mushrooms = MushroomTable.get(sender);
        MushroomTable.set(sender, mushrooms + 1);
    }
    function eat() public {
        address sender = _msgSender();
        int32 mushrooms = MushroomTable.get(sender);
        MushroomTable.set(sender, mushrooms - 1);
    }
}