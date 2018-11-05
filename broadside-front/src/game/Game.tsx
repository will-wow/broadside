import * as React from "react";
import styled from "../styled-components";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";

import Ship, { ShipData } from "./Ship";
import Bullet from "./Bullet";
import { BulletData } from "./Bullet";
import { Store } from "../reducers";
import * as GameSelectors from "./selectors";
import { onKeyChange, onGameConnect } from "./actions";
import ScoreCard from "./ScoreCard";

interface GameProps {
  gameId: string;
  bullets: BulletData[];
  fps: number;
  maxX: number;
  maxY: number;
  ships: ShipData[];
  isPlaying: boolean;
  userId: string;
  onKeyChange: typeof onKeyChange;
  onGameConnect: typeof onGameConnect;
}

class Game extends React.Component<GameProps> {
  handleKeyDown = ({ key }: KeyboardEvent): void => {
    const { onKeyChange, gameId, isPlaying } = this.props;

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
    const { gameId, onGameConnect } = this.props;

    onGameConnect(gameId);

    document.addEventListener("keydown", this.handleKeyDown, false);
    document.addEventListener("keyup", this.handleKeyUp, false);
  };

  componentWillUnmount = () => {
    document.removeEventListener("keydown", this.handleKeyDown, false);
    document.removeEventListener("keyup", this.handleKeyUp, false);
  };

  render() {
    const { fps, maxX, maxY, ships, bullets, isPlaying, userId } = this.props;
    return (
      <GameBackground isPlaying={isPlaying}>
        <ScoreCard />
        {ships.map(ship => (
          <Ship
            key={ship.id}
            fps={fps}
            maxX={maxX}
            maxY={maxY}
            ship={ship}
            userId={userId}
          />
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
      </GameBackground>
    );
  }
}

const GameBackground = styled.div`
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
    ships: GameSelectors.getShips(state),
    userId: state.menu.userId
  };
};

export const mapDispatchToProps = (dispatch: Dispatch) =>
  bindActionCreators(
    {
      onGameConnect,
      onKeyChange
    },
    dispatch
  );

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(Game);

export default connectedComponent;

export { Game };
