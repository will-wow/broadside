import * as React from "react";
import styled from "../styled-components";
import Ship from "./Ship";
import * as Utils from "../utils";

import * as Position from "./position";

interface MapState {
  shipPosition: Position.t;
}

const keysToChanges = {
  ArrowLeft: { attribute: "direction", direction: -1 },
  ArrowRight: { attribute: "direction", direction: 1 },
  a: { attribute: "x", direction: -1 },
  d: { attribute: "x", direction: 1 },
  s: { attribute: "y", direction: 1 },
  w: { attribute: "y", direction: -1 }
};

class Map extends React.Component<{}, MapState> {
  state = {
    shipPosition: {
      direction: 90,
      x: 20,
      y: 20
    }
  };

  handleKeypress = ({ key }: KeyboardEvent): void => {
    const changes = keysToChanges[key];

    if (!changes) {
      return;
    }

    let { shipPosition } = this.state;
    const { attribute, direction } = changes;

    shipPosition = Position.change(attribute)(direction)(shipPosition);

    this.setState({ shipPosition });
  };

  componentDidMount = () => {
    Utils.log("key")("press");

    document.addEventListener("keydown", this.handleKeypress, false);
  };

  componentWillUnmount = () =>
    document.removeEventListener("keydown", this.handleKeypress, false);

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
