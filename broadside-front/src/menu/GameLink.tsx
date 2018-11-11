import * as React from "react";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";

import { Store } from "../reducers";
import { onJoinGame } from "./actions";
import { Button } from "../styles/buttons";

interface GameLinkProps {
  game: string;
  onJoinGame: typeof onJoinGame;
}

class GameLink extends React.Component<GameLinkProps> {
  render() {
    const { game } = this.props;

    return <Button onClick={this.joinGame}>{game}</Button>;
  }

  private joinGame = () => {
    const { game, onJoinGame } = this.props;
    onJoinGame({ gameId: game });
  };
}

export const mapStateToProps = (_: Store) => ({});

export const mapDispatchToProps = (dispatch: Dispatch) =>
  bindActionCreators(
    {
      onJoinGame
    },
    dispatch
  );

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(GameLink);

export default connectedComponent;

export { GameLink };
