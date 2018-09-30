import * as React from "react";
import styled from "../styled-components";

import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";
import { Store } from "../reducers";
import { simple } from "../redex/action";

import GameLink from "./GameLink";

interface MenuProps {
  games: string[];
  onNewGame: () => void;
  onGetGames: () => void;
}

class Menu extends React.Component<MenuProps> {
  componentDidMount = () => {
    this.props.onGetGames();
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
      onGetGames: simple("get_games"),
      onNewGame: simple("new_game")
    },
    dispatch
  );

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(Menu);

export default connectedComponent;

export { Menu };
