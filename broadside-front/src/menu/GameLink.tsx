import * as React from "react";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";

import { Store } from "../reducers";
import { simple } from "../redex/action";

interface GameLinkProps {
  game: string;
  onJoinGame: (data: { game_id: string }) => void;
}

class GameLink extends React.Component<GameLinkProps> {
  render() {
    const { game } = this.props;

    return <button onClick={this.joinGame}>{game}</button>;
  }

  private joinGame = () => {
    const { game, onJoinGame } = this.props;
    onJoinGame({ game_id: game });
  };
}

export const mapStateToProps = (_: Store) => ({});

export const mapDispatchToProps = (dispatch: Dispatch) =>
  bindActionCreators(
    {
      onJoinGame: simple("join_game")
    },
    dispatch
  );

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(GameLink);

export default connectedComponent;

export { GameLink };
