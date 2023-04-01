import api from "./engine/api";
import Rules from "./Rules";
import Actions from "./Actions";
import History from "./History";
import Resources from "./Resources";
import { applyRates, checkConditions } from "./engine/logic";
import update from "immutability-helper";
import EditRule from "./RuleEditor";
import { useMUD } from "./MUDContext";
import { useEntityQuery, useComponentValue } from "@latticexyz/react";
import { getComponentValueStrict, Has } from "@latticexyz/recs";

export const App = () => {
  // setInterval(() => {
  //   applyRates();
  //   checkConditions();
  // }, 1000);
  const {
    components: { MushroomTable },
    world,
    worldSend
  } = useMUD();
  const playerEntities = useEntityQuery([Has(MushroomTable)]);
  console.log(playerEntities)
  return (
    <div>
      {/* <header>
        <img src="/assets/gnome.png" /> gnomik
      </header> */}
      <div className="panels">
        <ul>
          {playerEntities.map((playerIndex) => {
            const mushrooms = getComponentValueStrict(
              MushroomTable,
              playerIndex
            );
            return (
              <li>
                {world.entities[playerIndex]}: {mushrooms.value}
              </li>
            );
          })}
        </ul>
        <button onClick={() => {
          worldSend("gnomik_mushroom_produce", []);
        }}>produce</button>
        <button onClick={() => {
          worldSend("gnomik_mushroom_eat", []);
        }}>eat</button>
        {/* <Resources />
      <Actions />
      <History /> */}
      </div>
      {/* <Rules /> */}
    </div>
  );
};

export default App;
