import * as React from "react";
import styled from "../styled-components";
import axios from "axios";

import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";
import { Store } from "../reducers";

import { onSocketConnect, onChannelConnect } from "../redex/actions";

import { onNewGame, eventsToActions } from "./actions";

import GameLink from "./GameLink";

interface MenuProps {
  games: string[];
  onNewGame: typeof onNewGame;
  onSocketConnect: typeof onSocketConnect;
  onChannelConnect: typeof onChannelConnect;
}

const tokenEndpoint = "http://localhost:4000/api/users";

class Menu extends React.Component<MenuProps> {
  componentDidMount = async () => {
    const { onSocketConnect, onChannelConnect } = this.props;
    const {
      data: { token }
    } = await axios.post(tokenEndpoint);

    onSocketConnect({ token });
    onChannelConnect({
      eventsToActions,
      topic: "open_games:lobby"
    });
  };

  render() {
    const { games } = this.props;
    return (
      <MenuBackground>
        <button onClick={this.handleNewGame}>New Game</button>

        {games.map(game => <GameLink key={game} game={game} />)}
      </MenuBackground>
    );
  }

  private handleNewGame = () => this.props.onNewGame();
}

const MenuBackground = styled.div`
  width: 100vw;
  height: 100vh;
`;

export const mapStateToProps = (state: Store) => {
  return {
    games: state.menu.games
  };
};

export const mapDispatchToProps = (dispatch: Dispatch) =>
  bindActionCreators(
    {
      onChannelConnect,
      onNewGame,
      onSocketConnect
    },
    dispatch
  );

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(Menu);

export default connectedComponent;

export { Menu };
