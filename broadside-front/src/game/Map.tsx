import * as React from "react";
import styled from "../styled-components";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";

import Ship, { ShipData } from "./Ship";
import Bullet from "./Bullet";
import { BulletData } from "./Bullet";
import { Store } from "../reducers";
import * as GameSelectors from "./selectors";
import { simple } from "../redex/action";

interface MapProps {
  bullets: BulletData[];
  fps: number;
  ships: ShipData[];
  onKeyChange: (data: {event: string, key: string}) => void;
}

class Map extends React.Component<MapProps> {
  handleKeyDown = ({ key }: KeyboardEvent): void => {
    this.props.onKeyChange({ key, event: "down" });
  };

  handleKeyUp = ({ key }: KeyboardEvent): void => {
    this.props.onKeyChange({ key, event: "up" });
  };

  componentDidMount = async () => {
    document.addEventListener("keydown", this.handleKeyDown, false);
    document.addEventListener("keyup", this.handleKeyUp, false);
  };

  componentWillUnmount = () => {
    document.removeEventListener("keydown", this.handleKeyDown, false);
    document.removeEventListener("keyup", this.handleKeyUp, false);
  };

  render() {
    const { fps, ships, bullets } = this.props;
    return (
      <MapBackground>
        {ships.map(ship => <Ship fps={fps} key={ship.id} ship={ship} />)}
        {bullets.map(bullet => (
          <Bullet key={bullet.id} fps={fps} bullet={bullet} />
        ))}
      </MapBackground>
    );
  }
}

const MapBackground = styled.div`
  width: 100vw;
  height: 100vh;
  background: blue;
`;

export const mapStateToProps = (state: Store) => {
  return {
    bullets: state.game.bullets,
    fps: state.game.fps,
    ships: GameSelectors.getShips(state)
  };
};

export const mapDispatchToProps = (dispatch: Dispatch) =>
  bindActionCreators(
    {
      onKeyChange: simple("key_change")
    },
    dispatch
  );

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(Map);

export default connectedComponent;

export { Map };
