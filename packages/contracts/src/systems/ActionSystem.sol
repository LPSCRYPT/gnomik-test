pragma solidity >=0.8.0;
import { System } from "@latticexyz/world/src/System.sol";
import { ActionTable } from "../tables/ActionTable.sol";
import { ResourceTable } from "../tables/ResourceTable.sol";

contract ActionSystem is System {

    struct Data {
            int256 inputResourceAmount;
            int256 outputResourceAmount;
            int256 inputRate;
            int256 outputRate;
            string costFunction;
            string resultFunction;
            int256 costAmount;
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

        string memory costResource = ActionTable.getCostResource(_name);
        string memory resultResource = ActionTable.getResultResource(_name);
        bytes32 costResourceBytes = bytes32(abi.encodePacked(costResource));
        bytes32 resultResourceBytes = bytes32(abi.encodePacked(resultResource));

        // calc accrual for sender & target resource
        accrual(costResourceBytes, sender);
        if (sender != target || keccak256(bytes(costResource)) != keccak256(bytes(resultResource))) {
            accrual(resultResourceBytes, target);
        }

        Data memory ThisData;

        ThisData.inputResourceAmount = ResourceTable.getValue(costResourceBytes, sender);
        ThisData.outputResourceAmount = ResourceTable.getValue(resultResourceBytes, target);
        ThisData.inputRate = ResourceTable.getRate(costResourceBytes, sender);
        ThisData.outputRate = ResourceTable.getRate(resultResourceBytes, target);
        ThisData.costFunction = ActionTable.getCostFunction(_name);
        ThisData.resultFunction = ActionTable.getResultFunction(_name);
        ThisData.costAmount = ActionTable.getCostAmount(_name);
        ThisData.resultType = ActionTable.getResultType(_name);

        // input resource mutation

        if (keccak256(bytes(ThisData.costFunction)) == keccak256(bytes("add"))) {
            ResourceTable.set(bytes32(abi.encodePacked(costResource)), sender, ThisData.inputResourceAmount + ThisData.costAmount, block.timestamp, ThisData.inputRate);
        }
        if (keccak256(bytes(ThisData.costFunction)) == keccak256(bytes("sub"))) {
            ResourceTable.set(bytes32(abi.encodePacked(costResource)), sender, ThisData.inputResourceAmount - ThisData.costAmount, block.timestamp, ThisData.inputRate);
        }
        if (keccak256(bytes(ThisData.costFunction)) == keccak256(bytes("mul"))) {
            ResourceTable.set(bytes32(abi.encodePacked(costResource)), sender, ThisData.inputResourceAmount * ThisData.costAmount, block.timestamp, ThisData.inputRate);
        }
        if (keccak256(bytes(ThisData.costFunction)) == keccak256(bytes("div"))) {
            ResourceTable.set(bytes32(abi.encodePacked(costResource)), sender, ThisData.inputResourceAmount / ThisData.costAmount, block.timestamp, ThisData.inputRate);
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
   }

}