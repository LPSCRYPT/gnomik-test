import { mudConfig, resolveTableId } from "@latticexyz/cli";

export default mudConfig({
  namespace: "gnomik",
  overrideSystems: {
    ActionSystem : {
      fileSelector: "action",
      openAccess: true,
    }
  },
  tables: {
    ActionTable : {
      primaryKeys: {
        action: "bytes32"
      },
      schema : {
        costAmount1: "int256",
        costAmount2: "int256",
        selfTarget: "bool",
        resultAmount: "int256",
        costResource1: "string",
        costResource2: "string",
        costFunction: "string",
        resultResource: "string",
        resultFunction: "string",
        resultType: "string"
      }
    },
    ResourceTable : {
      primaryKeys: {
        resource: "bytes32",
        gnome: "address"
      },
      schema : {
        value: "int256",
        lastTimeUpdated: "uint256",
        rate: "int256"
      }
    }
  },
  modules: [
    // {
    //   name: "KeysWithValueModule",
    //   root: true,
    //   args: [resolveTableId("'CounterTable'")],
    // },
    // {
    //   name: "KeysWithValueModule",
    //   root: true,
    //   args: [resolveTableId("CounterTable")],
    // },
  ],
});
