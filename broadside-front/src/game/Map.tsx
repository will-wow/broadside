import * as React from "react";
import styled from "../styled-components";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";

import Ship, { ShipData } from "./Ship";
import Bullet from "./Bullet";
import { BulletData } from "./Bullet";
import { Store } from "../reducers";
import * as GameSelectors from "./selectors";
import { onKeyChange, eventsToActions } from "./actions";
import { onChannelConnect } from "../redex/actions";

interface MapProps {
  gameId: string;
  bullets: BulletData[];
  fps: number;
  maxX: number;
  maxY: number;
  ships: ShipData[];
  isPlaying: boolean;
  onKeyChange: typeof onKeyChange;
  onChannelConnect: typeof onChannelConnect;
}

class Map extends React.Component<MapProps> {
  handleKeyDown = ({ key }: KeyboardEvent): void => {
    const { onKeyChange, gameId, isPlaying } = this.props;

    // tslint:disable
    console.log(isPlaying);
    if (!isPlaying) {
      return;
    }

    onKeyChange(`game:${gameId}`, { key, event: "down" });
  };

  handleKeyUp = ({ key }: KeyboardEvent): void => {
    const { onKeyChange, gameId, isPlaying } = this.props;

    if (!isPlaying) {
      return;
    }

    onKeyChange(`game:${gameId}`, { key, event: "up" });
  };

  componentDidMount = async () => {
    const { gameId, onChannelConnect } = this.props;

    onChannelConnect({ topic: `game:${gameId}`, eventsToActions });

    document.addEventListener("keydown", this.handleKeyDown, false);
    document.addEventListener("keyup", this.handleKeyUp, false);
  };

  componentWillUnmount = () => {
    document.removeEventListener("keydown", this.handleKeyDown, false);
    document.removeEventListener("keyup", this.handleKeyUp, false);
  };

  render() {
    const { fps, maxX, maxY, ships, bullets, isPlaying } = this.props;
    return (
      <MapBackground isPlaying={isPlaying}>
        {ships.map(ship => (
          <Ship key={ship.id} fps={fps} maxX={maxX} maxY={maxY} ship={ship} />
        ))}
        {bullets.map(bullet => (
          <Bullet
            key={bullet.id}
            fps={fps}
            maxX={maxX}
            maxY={maxY}
            bullet={bullet}
          />
        ))}
      </MapBackground>
    );
  }
}

const MapBackground = styled.div`
  width: 100vw;
  height: 100vh;
  background: blue;
  position: relative;
  ${({ isPlaying }: { isPlaying: boolean }) =>
    !isPlaying &&
    `
    &:after {
      content: " ";
      background: white;
      opacity: 0.5;
      position: absolute;
      top: 0;
      left: 0;
      bottom: 0;
      right: 0
    }`}
  }
`;

export const mapStateToProps = (state: Store) => {
  return {
    bullets: state.game.bullets,
    fps: state.constants.fps,
    gameId: state.game.gameId,
    isPlaying: GameSelectors.isPlaying(state),
    maxX: state.constants.maxX,
    maxY: state.constants.maxY,
    ships: GameSelectors.getShips(state)
  };
};

export const mapDispatchToProps = (dispatch: Dispatch) =>
  bindActionCreators(
    {
      onChannelConnect,
      onKeyChange
    },
    dispatch
  );

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(Map);

export default connectedComponent;

export { Map };
