import * as React from "react";
import * as R from "ramda";
import styled from "../styled-components";
import Ship from "./Ship";

import * as Position from "./position";
import * as KeysDown from "./keys-down";

interface MapState {
  shipPosition: Position.t;
  keysDown: KeysDown.t;
}

// TODO: This should be heading & velocity
const keysToChanges: Position.ChangeDictionary = {
  a: { attribute: "heading", direction: -1 },
  d: { attribute: "heading", direction: 1 },
  s: { attribute: "velocity", direction: -1 },
  w: { attribute: "velocity", direction: 1 }
};

class Map extends React.Component<{}, MapState> {
  state: MapState = {
    keysDown: {},
    shipPosition: {
      heading: 90,
      velocity: 0,
      x: 20,
      y: 20
    }
  };
  interval: NodeJS.Timer;

  updatePosition = () => {
    let { shipPosition } = this.state;
    const { keysDown } = this.state;

    shipPosition = R.pipe(
      KeysDown.pressedKeys,
      R.reduce(
        (position, key) => Position.changeFromKey(keysToChanges, key, position),
        shipPosition
      ),
      Position.turn
    )(keysDown);

    this.setState({ shipPosition });
  };

  handleKeyDown = (event: KeyboardEvent): void => {
    let { keysDown } = this.state;

    keysDown = KeysDown.recordKeyDown(keysDown, event);

    this.setState({ keysDown });
  };

  handleKeyUp = (event: KeyboardEvent): void => {
    let { keysDown } = this.state;

    keysDown = KeysDown.recordKeyUp(keysDown, event);

    this.setState({ keysDown });
  };

  componentDidMount = () => {
    document.addEventListener("keydown", this.handleKeyDown, false);
    document.addEventListener("keyup", this.handleKeyUp, false);

    this.interval = setInterval(this.updatePosition, 1 / 24);
  };

  componentWillUnmount = () => {
    document.removeEventListener("keydown", this.handleKeyDown, false);
    document.removeEventListener("keyup", this.handleKeyUp, false);

    clearInterval(this.interval);
  };

  render() {
    const { shipPosition } = this.state;
    return (
      <MapBackground>
        <Ship shipPosition={shipPosition} />
      </MapBackground>
    );
  }
}

const MapBackground = styled.div`
  width: 100vw;
  height: 100vh;
  background: blue;
`;

export default Map;
