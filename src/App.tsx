import * as React from "react";
import logo from "./logo.svg";
import "./App.css";

class App extends React.Component {
  render() {
    return (
      <div className="App">
        <header className="App__header">
          <img src={logo} className="App__logo" alt="logo" />
          <h1 className="App__title">Welcome to React</h1>
        </header>
        <p className="App__intro">
          To get started, edit <code>src/App.tsx</code> and save to reload.
        </p>
      </div>
    );
  }
}

export default App;
