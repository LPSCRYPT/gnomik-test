import { ethers } from 'ethers';
import { For, createSignal } from 'solid-js';
import { world, components } from "./engine/api";

const { HistoryTable } = components;

const HISTORY_LENGTH = 15;

function getRand(items: string[]): string {
  return items[Math.floor(Math.random()*items.length)];
}

const ACTION_DESCS: Record<string, string[]> = {
  gather: [
    '${actor} gathered a mushroom.',
    '${actor} found a tasty mushroom.',
    '${actor} foraged a questionable mushroom.',
    '${actor} stumbled upon a rare mushroom.',
  ],
  eat: [
    '${actor} ate a mushroom.',
    '${actor} enjoyed a mushroom.',
    '${actor} feasted on a mushroom.',
    '${actor} devoured a mushroom.',
  ],
  think: [
    '${actor} thought about things.',
    '${actor} got lost in thought.',
  ],
  read: [
    '${actor} read something interesting.',
    '${actor} leafed through a nice book.',
    '${actor} read a challenging article.',
    '${actor} browsed Wikipedia for a bit.',
    '${actor} skimmed through a strange textbook.',
  ],
  buildShroomFarm: [
    '${actor} built a shroom farm.',
    '${actor} established a new shroom farm.',
    '${actor} founded a shroom farm.',
  ],
  sabotageShroomFarm: [
    '${actor} mercilessly destroyed ${target}\'s shroom farm.',
    '${actor} brutally sabotaged ${target}\'s shroom farm.',
    '${actor} left ${target}\s shroom farm in ruins.',
  ],
  ferment: [
    '${actor} fermented some tasty mushrooms.',
    '${actor} let some shrooms stew for awhile.',
  ],
  wanderInTheForest: [
    '${actor} wandered in the forest for awhile.',
    '${actor} got lost in the woods.',
  ],
  haveAGnomeParty: [
    '${actor} threw a party with some friends.',
    '${actor} had a grand celebration.',
  ],
  giftMushrooms: [
    '${actor} sent ${target} some tasty mushrooms.',
    '${actor} gifted ${target} some delectable shrooms.',
  ],
  teach: [
    '${actor} taught ${target} about some things.',
    '${actor} lectured ${target} for awhile.',
  ],
  giftGoldCoins: [
    '${actor} bribed ${target}.',
    '${actor} gave ${target} some gold coins.',
  ],
  stealHat: [
    'Thief! ${actor} stole ${target}\'s hat.',
  ],
  proposeRule: [
    '${actor} changed a rule.',
  ]
}

const inject = (str: string, obj: Object) => str.replace(/\${(.*?)}/g, (x,g)=> obj[g]);


type History = string[];

export default function History() {
  const [history, setHistory] = createSignal<History>([]);

  HistoryTable.update$.subscribe((change) => {
    let [nextValue, _prevValue] = change.value;
    if (nextValue !== undefined) {
      let key = world.entities[change.entity];
      let [actionName, addr, _] = key.split(':');
      actionName = ethers.utils.parseBytes32String(actionName);

      let event = inject(getRand(ACTION_DESCS[actionName] || ['${actor} did ' + actionName + '.']), {
        actor: addr,
        target: nextValue.target,
      });

      let h = [...history()];
      h.push(event);
      setHistory(h);
    }
  });

  const historyReverse = () => history().slice().reverse();

  return <div class="panel history">
    <h2>History</h2>
    <For each={historyReverse().slice(0, HISTORY_LENGTH)}>
      {(event, i) => {
        return <div style={{opacity: 1-(Math.sqrt(i()/HISTORY_LENGTH))}}>{event}</div>
      }}
    </For>
  </div>
}


