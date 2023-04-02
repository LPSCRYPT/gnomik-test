import Rules from "./Rules";
import Actions from "./Actions";
import History from "./History";
import Resources from "./Resources";
import EditRule from "./RuleEditor";

import { Has } from "@latticexyz/recs";
import { defineQuery } from "@latticexyz/recs";
import { components } from "./engine/api";

export const App = () => {
  let { ResourceTable } = components;
  let stableFragments = [Has(ResourceTable)];
  const query = defineQuery(stableFragments, { runOnInit: true });
  console.log([...query.matching]);

  return <div>
    <header>
      <img src="/assets/gnome.png" /> gnomik
    </header>
    <div class="panels">
      <Resources />
      <Actions />
    </div>
    <Rules />
  </div>
};

export default App;
