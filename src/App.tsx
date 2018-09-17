import * as React from "react";
import logo from "./logo.svg";
import "./App.css";
import Map from "./game/Map";

class App extends React.Component {
  render() {
    return (
      <div className="App">
        <Map />
      </div>
    );
  }
}

export default App;
