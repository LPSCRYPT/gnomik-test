pragma solidity >=0.8.0;
import { System } from "@latticexyz/world/src/System.sol";
import { HistoryTable } from "../tables/HistoryTable.sol";
import { ActionTable } from "../tables/ActionTable.sol";
import { ResourceTable } from "../tables/ResourceTable.sol";
import { console } from 'forge-std/console.sol';

contract ActionSystem is System {

    struct Data {
            int256 inputResourceAmount1;
            int256 inputResourceAmount2;
            int256 outputResourceAmount;
            int256 inputRate1;
            int256 inputRate2;
            int256 outputRate;
            string costFunction;
            string resultFunction;
            int256 costAmount1;
            int256 costAmount2;
            string resultType;
        }

    function accrual(bytes32 _resource, address _user) internal {
        int256 t0 = int(ResourceTable.getLastTimeUpdated(_resource, _user));
        int256 rate = ResourceTable.getRate(_resource, _user);
        int256 accrue = (int(block.timestamp) - t0) * rate;
        int256 resourceAmount = ResourceTable.getValue(_resource, _user);
        ResourceTable.set(_resource, _user, resourceAmount + accrue, block.timestamp, rate);
    }

    function callAction(bytes32 _name, address _target) public {
        address sender = _msgSender();
        address target = _target;
        if (ActionTable.getSelfTarget(_name)) {
            target = sender;
        }

        string memory costResource1 = ActionTable.getCostResource1(_name);
        string memory costResource2 = ActionTable.getCostResource2(_name);
        string memory resultResource = ActionTable.getResultResource(_name);
        bytes32 costResourceBytes1 = bytes32(abi.encodePacked(costResource1));
        bytes32 costResourceBytes2 = bytes32(abi.encodePacked(costResource2));
        bytes32 resultResourceBytes = bytes32(abi.encodePacked(resultResource));

        // calc accrual for sender & target resource
        accrual(costResourceBytes1, sender);
        if (costResourceBytes2 != bytes32(abi.encodePacked(""))) {
            accrual(costResourceBytes2, sender);
        }
        if (sender != target || (keccak256(bytes(costResource1)) != keccak256(bytes(resultResource)) && keccak256(bytes(costResource2)) != keccak256(bytes(resultResource)))) {
            accrual(resultResourceBytes, target);
        }

        Data memory ThisData;

        ThisData.inputResourceAmount1 = ResourceTable.getValue(costResourceBytes1, sender);
        ThisData.inputResourceAmount2 = ResourceTable.getValue(costResourceBytes2, sender);
        ThisData.outputResourceAmount = ResourceTable.getValue(resultResourceBytes, target);
        ThisData.inputRate1 = ResourceTable.getRate(costResourceBytes1, sender);
        ThisData.inputRate2 = ResourceTable.getRate(costResourceBytes2, sender);
        ThisData.outputRate = ResourceTable.getRate(resultResourceBytes, target);
        ThisData.costFunction = ActionTable.getCostFunction(_name);
        ThisData.resultFunction = ActionTable.getResultFunction(_name);
        ThisData.costAmount1 = ActionTable.getCostAmount1(_name);
        ThisData.costAmount2 = ActionTable.getCostAmount2(_name);
        ThisData.resultType = ActionTable.getResultType(_name);

        // input resource mutation

        if (keccak256(bytes(ThisData.costFunction)) == keccak256(bytes("add"))) {
            ResourceTable.set(bytes32(abi.encodePacked(costResource1)), sender, ThisData.inputResourceAmount1 + ThisData.costAmount1, block.timestamp, ThisData.inputRate1);
        }
        // console.log(ThisData.costFunction);
        if (keccak256(bytes(ThisData.costFunction)) == keccak256(bytes("sub"))) {
            console.log('interior');
            // require(,"");
            ResourceTable.set(bytes32(abi.encodePacked(costResource1)), sender,
            ThisData.inputResourceAmount1 - ThisData.costAmount1,
            block.timestamp, ThisData.inputRate1);
        }
        // console.logInt(ResourceTable.getValue(bytes32(abi.encodePacked("mushroom")), sender));
        if (keccak256(bytes(ThisData.costFunction)) == keccak256(bytes("mul"))) {
            ResourceTable.set(bytes32(abi.encodePacked(costResource1)), sender, ThisData.inputResourceAmount1 * ThisData.costAmount1, block.timestamp, ThisData.inputRate1);
        }
        if (keccak256(bytes(ThisData.costFunction)) == keccak256(bytes("div"))) {
            ResourceTable.set(bytes32(abi.encodePacked(costResource1)), sender, ThisData.inputResourceAmount1 / ThisData.costAmount1, block.timestamp, ThisData.inputRate1);
        }

        if (costResourceBytes2 != bytes32(abi.encodePacked(""))) {
            if (keccak256(bytes(ThisData.costFunction)) == keccak256(bytes("add"))) {
            ResourceTable.set(bytes32(abi.encodePacked(costResource2)), sender, ThisData.inputResourceAmount2 + ThisData.costAmount2, block.timestamp, ThisData.inputRate2);
            }
            if (keccak256(bytes(ThisData.costFunction)) == keccak256(bytes("sub"))) {
                // require(,"");
                ResourceTable.set(bytes32(abi.encodePacked(costResource2)), sender, ThisData.inputResourceAmount2 - ThisData.costAmount2, block.timestamp, ThisData.inputRate2);
            }
            if (keccak256(bytes(ThisData.costFunction)) == keccak256(bytes("mul"))) {
                ResourceTable.set(bytes32(abi.encodePacked(costResource2)), sender, ThisData.inputResourceAmount2 * ThisData.costAmount2, block.timestamp, ThisData.inputRate2);
            }
            if (keccak256(bytes(ThisData.costFunction)) == keccak256(bytes("div"))) {
                ResourceTable.set(bytes32(abi.encodePacked(costResource2)), sender, ThisData.inputResourceAmount2 / ThisData.costAmount2, block.timestamp, ThisData.inputRate2);
            }
        }

        // output resource mutation
        int256 numModAdd = 0;
        int256 numModMul = 1;
        int256 rateModAdd = 0;
        int256 rateModMul = 1;

        if (keccak256(bytes(ThisData.resultType)) == keccak256(bytes("resource"))) {
            numModAdd = ActionTable.getResultAmount(_name);
            numModMul = numModAdd;

        } else {
            rateModAdd = ActionTable.getResultAmount(_name);
            rateModMul = rateModAdd;
        }

        if (keccak256(bytes(ThisData.resultFunction)) == keccak256(bytes("add"))) {
            ResourceTable.set(bytes32(abi.encodePacked(resultResource)), target, ThisData.outputResourceAmount + numModAdd, block.timestamp, ThisData.outputRate + rateModAdd);
        }
        if (keccak256(bytes(ThisData.resultFunction)) == keccak256(bytes("sub"))) {
            ResourceTable.set(bytes32(abi.encodePacked(resultResource)), target, ThisData.outputResourceAmount - numModAdd, block.timestamp, ThisData.outputRate - rateModAdd);
        }
        if (keccak256(bytes(ThisData.resultFunction)) == keccak256(bytes("mul"))) {
            ResourceTable.set(bytes32(abi.encodePacked(resultResource)), target, ThisData.outputResourceAmount * numModMul, block.timestamp, ThisData.outputRate * rateModMul);
        }
        if (keccak256(bytes(ThisData.resultFunction)) == keccak256(bytes("div"))) {
            ResourceTable.set(bytes32(abi.encodePacked(resultResource)), target, ThisData.outputResourceAmount / numModMul, block.timestamp, ThisData.outputRate / rateModMul);
        }

        HistoryTable.set(bytes32(abi.encodePacked(_name)), sender, block.timestamp, target);
   }

}