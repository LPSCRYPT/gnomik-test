import { ethers } from 'ethers';
import { numFmt } from './format';
import { ResourceName } from './engine/state';
import { For, createSignal } from 'solid-js';
import { me, world, components } from "./engine/api";
import update from 'immutability-helper';

const { ResourceTable } = components;
type Resources = Record<string, {
  value: number,
  rate: number,
}>


export const icons: Record<ResourceName, string> = {
  energy: "/assets/img/energy.png",
  thoughts: "/assets/img/thought.png",
  hamburgers: "/assets/img/hamburger.png",
  mushrooms: "/assets/img/mushroom.png",
}

export default function Resources() {
  let [resources, setResources] = createSignal<Resources>({});

  ResourceTable.update$.subscribe((change) => {
    let [nextValue, _prevValue] = change.value;
    if (nextValue !== undefined) {
      let key = world.entities[change.entity];
      let [resourceName, addr] = key.split(':');
      if (addr.startsWith(me as string)) {
        resourceName = ethers.utils.parseBytes32String(resourceName);
        setResources(update(resources(), {
          [resourceName]: {$set: {
            value: Number(nextValue.value),
            rate: Number(nextValue.rate),
          }}
        }));
      }
    }
  });

  return <div class="panel resources">
    <h2>Resources</h2>
    <For each={Object.entries(resources())}>
      {([name, data]) => {
        return <div class="resource">
          <div class="resource-name">
            <img src={icons[name as ResourceName]} /> {name}
          </div>
          <div class="resource-rate">
            {data.rate != 0 ? `${data.rate < 0 ? "":"+"}${data.rate}/sec` : ''}
          </div>
          <div class="resource-value">{numFmt(data.value)}</div>
        </div>
      }}
    </For>
  </div>
}
