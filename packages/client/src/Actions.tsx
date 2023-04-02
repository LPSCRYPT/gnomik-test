import { ethers } from 'ethers';
import { numFmt } from './format';
import { ActionName } from './engine/state';
import { For, createSignal } from 'solid-js';
import { icons } from './Resources';
import { callAction, world, components } from "./engine/api";
import update from 'immutability-helper';
import { runQuery, Has, getComponentValueStrict } from '@latticexyz/recs';

const { ActionTable } = components;
type Actions = Record<string, {
  targeted: boolean,
  costs: Record<string, number>,
}>

export function ChooseActor(props: {
  onSelect: (actor: string) => void,
}) {
  const otherPlayers = [] as any // TODO;
  return <div class="choose-target">
    <h2>Choose Target</h2>
    <For each={otherPlayers}>
      {(actor) => {
        return <div class="other-actor" onClick={() => props.onSelect(actor)}>
          <div>{actor}</div>
          <div class="other-actor-resources">{numFmt(12379)}<img src="/assets/img/mushroom.png" class="icon" /></div>
        </div>
      }}
    </For>
  </div>
}

export default function Actions() {
  const [actions, setActions] = createSignal<Actions>({});
  const doAction = (action: ActionName, target?: string) => {
    callAction(action, target);
  }

  const entities = runQuery([Has(ActionTable)]);
  console.log('entities:', entities);
  // console.log(getComponentValueStrict(ActionTable, entities[0]));

  ActionTable.update$.subscribe((change) => {
    let [nextValue, _prevValue] = change.value;
    if (nextValue !== undefined) {
      let key = world.entities[change.entity];
      let [actionName, _addr] = key.split(':');
      actionName = ethers.utils.parseBytes32String(actionName);

      let costs: Record<string, number> = {};
      if (nextValue.costResource1) {
        costs[nextValue.costResource1] = Number(nextValue.costAmount1);
      }
      if (nextValue.costResource2) {
        costs[nextValue.costResource2] = Number(nextValue.costAmount2);
      }

      setActions(update(actions(), {
        [actionName]: {$set: {
          targeted: !nextValue.selfTarget,
          costs,
        }}
      }));
    }
  });

  return <div class="panel actions">
    <h2>Actions</h2>
    <For each={Object.entries(actions())}>
      {([name, data]) => {
        console.log(data.costs);
        return <div class="action" onClick={() => !data.targeted && doAction(name)}>
          <div class="action-name">{name}</div>
          {Object.keys(data.costs).length > 0 && <div class="action-requires">Requires
            <For each={Object.entries(data.costs)}>
              {([name, amount]) => {
                return <div class="action-requirement">{amount} {name}</div>
              }}
            </For>
          </div>}
          {data.targeted && <ChooseActor onSelect={(target) => doAction(name, target)} />}
        </div>
      }}
    </For>
  </div>
}

