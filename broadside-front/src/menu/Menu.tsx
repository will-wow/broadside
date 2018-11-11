import * as React from "react";
import styled from "../styled-components";
import axios from "axios";
import { serverUrl } from "../lib/endpoints";

import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";
import { Store } from "../reducers";

import { onNewGame, onSocketConnect, onLobbyConnect } from "./actions";

import GameLink from "./GameLink";

import battle1 from "../img/battle-1.jpg";
import battle2 from "../img/battle-2.jpg";
import battle3 from "../img/battle-3.jpg";
import battle4 from "../img/battle-4.jpg";
import battle5 from "../img/battle-5.jpg";

import * as Utils from '../lib/utils';


import * as Colors from "../styles/colors";
import { Button } from "../styles/buttons";

const backgrounds = [battle1, battle2, battle3, battle4, battle5];

interface MenuProps {
  games: string[];
  onNewGame: typeof onNewGame;
  onSocketConnect: typeof onSocketConnect;
  onLobbyConnect: typeof onLobbyConnect;
}

const tokenEndpoint = serverUrl("http", "api/users");

class Menu extends React.Component<MenuProps> {
  componentDidMount = async () => {
    const { onSocketConnect, onLobbyConnect } = this.props;
    const {
      data: { token }
    } = await axios.post(tokenEndpoint);

    onSocketConnect(token);
    onLobbyConnect();
  };

  render() {
    const { games } = this.props;
    return (
      <MenuBackground>
        <Title>Broadside</Title>
        <Button onClick={this.handleNewGame}>New Game</Button>

        <SectionTitle>In-Progress Games</SectionTitle>
        <Games>{games.map(game => <GameLink key={game} game={game} />)}</Games>
      </MenuBackground>
    );
  }

  private handleNewGame = () => this.props.onNewGame();
}

const MenuBackground = styled.div`
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: ${Colors.paper};
  background-image: url(${Utils.sample(backgrounds)});
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  padding: 3rem;
`;

const Title = styled.div`
  color: ${Colors.pencil};
  font-size: 3rem;
  margin-top: 1rem;
`;

const SectionTitle = styled.div`
  color: ${Colors.pencil};
  font-size: 1.5rem;
  margin-top: 1rem;
`;

const Games = styled.div`
  margin-top: 1rem;
  display: flex;
  flex-wrap: wrap;
  max-width: 800px;
  justify-content: center;

  & * {
    margin-right: 0.5rem;
    margin-bottom: 0.5rem;
    &:last-child {
      margin-right: 0;
    }
  }
`;

export const mapStateToProps = (state: Store) => {
  return {
    games: state.menu.games
  };
};

export const mapDispatchToProps = (dispatch: Dispatch) =>
  bindActionCreators(
    {
      onLobbyConnect,
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
