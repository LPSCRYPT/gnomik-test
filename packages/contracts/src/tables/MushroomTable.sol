// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

// Import schema type
import { SchemaType } from "@latticexyz/schema-type/src/solidity/SchemaType.sol";

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { Schema, SchemaLib } from "@latticexyz/store/src/Schema.sol";
import { PackedCounter, PackedCounterLib } from "@latticexyz/store/src/PackedCounter.sol";

uint256 constant _tableId = uint256(bytes32(abi.encodePacked(bytes16("gnomik"), bytes16("MushroomTable"))));
uint256 constant MushroomTableTableId = _tableId;

struct MushroomTableData {
  uint256 value;
  uint256 lastTimeUpdated;
  uint256 rate;
}

library MushroomTable {
  /** Get the table's schema */
  function getSchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](3);
    _schema[0] = SchemaType.UINT256;
    _schema[1] = SchemaType.UINT256;
    _schema[2] = SchemaType.UINT256;

    return SchemaLib.encode(_schema);
  }

  function getKeySchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](1);
    _schema[0] = SchemaType.ADDRESS;

    return SchemaLib.encode(_schema);
  }

  /** Get the table's metadata */
  function getMetadata() internal pure returns (string memory, string[] memory) {
    string[] memory _fieldNames = new string[](3);
    _fieldNames[0] = "value";
    _fieldNames[1] = "lastTimeUpdated";
    _fieldNames[2] = "rate";
    return ("MushroomTable", _fieldNames);
  }

  /** Register the table's schema */
  function registerSchema() internal {
    StoreSwitch.registerSchema(_tableId, getSchema(), getKeySchema());
  }

  /** Register the table's schema (using the specified store) */
  function registerSchema(IStore _store) internal {
    _store.registerSchema(_tableId, getSchema(), getKeySchema());
  }

  /** Set the table's metadata */
  function setMetadata() internal {
    (string memory _tableName, string[] memory _fieldNames) = getMetadata();
    StoreSwitch.setMetadata(_tableId, _tableName, _fieldNames);
  }

  /** Set the table's metadata (using the specified store) */
  function setMetadata(IStore _store) internal {
    (string memory _tableName, string[] memory _fieldNames) = getMetadata();
    _store.setMetadata(_tableId, _tableName, _fieldNames);
  }

  /** Get value */
  function getValue(address player) internal view returns (uint256 value) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    bytes memory _blob = StoreSwitch.getField(_tableId, _primaryKeys, 0);
    return (uint256(Bytes.slice32(_blob, 0)));
  }

  /** Get value (using the specified store) */
  function getValue(IStore _store, address player) internal view returns (uint256 value) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    bytes memory _blob = _store.getField(_tableId, _primaryKeys, 0);
    return (uint256(Bytes.slice32(_blob, 0)));
  }

  /** Set value */
  function setValue(address player, uint256 value) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    StoreSwitch.setField(_tableId, _primaryKeys, 0, abi.encodePacked((value)));
  }

  /** Set value (using the specified store) */
  function setValue(IStore _store, address player, uint256 value) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    _store.setField(_tableId, _primaryKeys, 0, abi.encodePacked((value)));
  }

  /** Get lastTimeUpdated */
  function getLastTimeUpdated(address player) internal view returns (uint256 lastTimeUpdated) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    bytes memory _blob = StoreSwitch.getField(_tableId, _primaryKeys, 1);
    return (uint256(Bytes.slice32(_blob, 0)));
  }

  /** Get lastTimeUpdated (using the specified store) */
  function getLastTimeUpdated(IStore _store, address player) internal view returns (uint256 lastTimeUpdated) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    bytes memory _blob = _store.getField(_tableId, _primaryKeys, 1);
    return (uint256(Bytes.slice32(_blob, 0)));
  }

  /** Set lastTimeUpdated */
  function setLastTimeUpdated(address player, uint256 lastTimeUpdated) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    StoreSwitch.setField(_tableId, _primaryKeys, 1, abi.encodePacked((lastTimeUpdated)));
  }

  /** Set lastTimeUpdated (using the specified store) */
  function setLastTimeUpdated(IStore _store, address player, uint256 lastTimeUpdated) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    _store.setField(_tableId, _primaryKeys, 1, abi.encodePacked((lastTimeUpdated)));
  }

  /** Get rate */
  function getRate(address player) internal view returns (uint256 rate) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    bytes memory _blob = StoreSwitch.getField(_tableId, _primaryKeys, 2);
    return (uint256(Bytes.slice32(_blob, 0)));
  }

  /** Get rate (using the specified store) */
  function getRate(IStore _store, address player) internal view returns (uint256 rate) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    bytes memory _blob = _store.getField(_tableId, _primaryKeys, 2);
    return (uint256(Bytes.slice32(_blob, 0)));
  }

  /** Set rate */
  function setRate(address player, uint256 rate) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    StoreSwitch.setField(_tableId, _primaryKeys, 2, abi.encodePacked((rate)));
  }

  /** Set rate (using the specified store) */
  function setRate(IStore _store, address player, uint256 rate) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    _store.setField(_tableId, _primaryKeys, 2, abi.encodePacked((rate)));
  }

  /** Get the full data */
  function get(address player) internal view returns (MushroomTableData memory _table) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    bytes memory _blob = StoreSwitch.getRecord(_tableId, _primaryKeys, getSchema());
    return decode(_blob);
  }

  /** Get the full data (using the specified store) */
  function get(IStore _store, address player) internal view returns (MushroomTableData memory _table) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    bytes memory _blob = _store.getRecord(_tableId, _primaryKeys, getSchema());
    return decode(_blob);
  }

  /** Set the full data using individual values */
  function set(address player, uint256 value, uint256 lastTimeUpdated, uint256 rate) internal {
    bytes memory _data = encode(value, lastTimeUpdated, rate);

    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    StoreSwitch.setRecord(_tableId, _primaryKeys, _data);
  }

  /** Set the full data using individual values (using the specified store) */
  function set(IStore _store, address player, uint256 value, uint256 lastTimeUpdated, uint256 rate) internal {
    bytes memory _data = encode(value, lastTimeUpdated, rate);

    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    _store.setRecord(_tableId, _primaryKeys, _data);
  }

  /** Set the full data using the data struct */
  function set(address player, MushroomTableData memory _table) internal {
    set(player, _table.value, _table.lastTimeUpdated, _table.rate);
  }

  /** Set the full data using the data struct (using the specified store) */
  function set(IStore _store, address player, MushroomTableData memory _table) internal {
    set(_store, player, _table.value, _table.lastTimeUpdated, _table.rate);
  }

  /** Decode the tightly packed blob using this table's schema */
  function decode(bytes memory _blob) internal pure returns (MushroomTableData memory _table) {
    _table.value = (uint256(Bytes.slice32(_blob, 0)));

    _table.lastTimeUpdated = (uint256(Bytes.slice32(_blob, 32)));

    _table.rate = (uint256(Bytes.slice32(_blob, 64)));
  }

  /** Tightly pack full data using this table's schema */
  function encode(uint256 value, uint256 lastTimeUpdated, uint256 rate) internal view returns (bytes memory) {
    return abi.encodePacked(value, lastTimeUpdated, rate);
  }

  /* Delete all data for given keys */
  function deleteRecord(address player) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    StoreSwitch.deleteRecord(_tableId, _primaryKeys);
  }

  /* Delete all data for given keys (using the specified store) */
  function deleteRecord(IStore _store, address player) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(bytes20((player)));

    _store.deleteRecord(_tableId, _primaryKeys);
  }
}
