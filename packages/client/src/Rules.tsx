import { ethers } from 'ethers';
import { For, createSignal } from "solid-js";
import { icons } from './Resources';
import update from 'immutability-helper';
import { world, components } from "./engine/api";

const { ActionTable } = components;
interface Action {
  targeted: boolean,
  costs: Record<string, number>,
  costFunction: string,
  resourceChange: {
    resource: string,
    type: string,
    function: string,
    amount: number,
  }
}
type Actions = Record<string, Action>;

function EditRule(props: {name: string, action: Action}) {
  // TODO
}

function Rule(props: {name: string, action: Action}) {
  return <div>
    "{props.name}", changes {props.action.resourceChange.resource} {props.action.resourceChange.type} by {props.action.resourceChange.amount}
    {Object.keys(props.action.costs).length > 0 && <span>
      <For each={Object.entries(props.action.costs)}>
        {([name, amount]) => {
          return <div class="action-requirement">{amount} <img src={icons[name]} class="icon" /></div>
        }}
      </For>
    </span>}

  </div>
}

export default function Rules() {
  const [actions, setActions] = createSignal<Actions>({});

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

      let action = {
        targeted: !nextValue.selfTarget,
        costs,
        costFunction: nextValue.costFunction,
        resourceChange: {
          resource: nextValue.resultResource,
          function: nextValue.resultFunction,
          type: nextValue.resultType,
          amount: Number(nextValue.resultAmount)
        }
      }
      setActions(update(actions(), {
        [actionName]: {$set: action}
      }));
    }
  });

  return <div class="panel rules">
    <h2>Rules</h2>
    <For each={Object.entries(actions())}>
      {([name, action]) => <Rule name={name} action={action} />}
    </For>
  </div>
}
