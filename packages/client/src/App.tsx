import Rules from "./Rules";
import Actions from "./Actions";
import History from "./History";
import Resources from "./Resources";

export const App = () => {
  return <div>
    <img class="mushroom" src="/assets/mushroom.gif" />
    <header>
      <img src="/assets/gnome.png" /> gnomik
    </header>
    <div class="panels">
      <Resources />
      <Actions />
      <History />
    </div>
    <Rules />
  </div>
};

export default App;
