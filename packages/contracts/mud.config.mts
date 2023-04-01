import { mudConfig, resolveTableId } from "@latticexyz/cli";

export default mudConfig({
  namespace: "gnomik",
  overrideSystems: {
    MushroomSystem: {
      fileSelector: "mushroom",
      openAccess: true,
    },
  },
  tables: {
    MushroomTable: {
      primaryKeys: {
        player: "address"
      },
      schema: {
        value: "int32"
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
