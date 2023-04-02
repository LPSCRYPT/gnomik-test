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
import { ethers } from 'ethers';

export const App = () => {
  // setInterval(() => {
  //   applyRates();
  //   checkConditions();
  // }, 1000);
  const {
    components: { MushroomTable, ThoughtTable },
    world,
    worldSend
  } = useMUD();
  const playerEntities = useEntityQuery([Has(MushroomTable)]);
  console.log('playerEntities, ',playerEntities)
  return (
    //@ts-ignore
    <div>
      {/* <header>
        <img src="/assets/gnome.png" /> gnomik
      </header> */}
      <div className="panels">
        <div>Mushrooms</div>
        <ul>
          {playerEntities.map((playerIndex) => {
            try{
              const mushrooms = getComponentValueStrict(
                MushroomTable,
                playerIndex
              );
              console.log('mushrooms ',mushrooms)
              return (
                <li>
                  {world.entities[playerIndex]}: Amount:{ ethers.utils.formatUnits(mushrooms.value, 0)}, Rate: +{ethers.utils.formatUnits(mushrooms.rate, 0)}/s
                </li>
              );
               } catch (e) {
              console.log('mushrooms err, ',e)
            }
          })}
        </ul>
        <button onClick={() => {
          worldSend("gnomik_mushroom_produce", []);
        }}>gather (+1 shroom)</button>
        <button onClick={() => {
          worldSend("gnomik_mushroom_eat", []);
        }}>eat (-1 shroom, +1 shroom/s)</button>
        <button onClick={() => {
          worldSend("gnomik_thought_think", []);
        }}>think (-100 shroom, +1 thought)</button>
        {/* <Resources />
      <Actions />
      <History /> */}
      </div>
      <br/>
      <div>Thoughts</div>
      <ul>
      {playerEntities.map((playerIndex) => {
        try{
          const thoughts = getComponentValueStrict(
            ThoughtTable,
            playerIndex
          );
          console.log('mushrooms ',thoughts)
          return (
            <li>
              {world.entities[playerIndex]}: Amount:{ethers.utils.formatUnits(thoughts.value, 0)}, Rate: +{ethers.utils.formatUnits(thoughts.rate, 0)}/s
            </li>
          );
          } catch(e) {
            console.log('thoughts err, ',e)
          }
          })}
      </ul>
      <button onClick={() => {
          worldSend("gnomik_thought_read", []);
        }}>read (-15,000 shroom, -100 thought, +1 thought/s)</button>
      {/* <Rules /> */}
    </div>
  );
};

export default App;
