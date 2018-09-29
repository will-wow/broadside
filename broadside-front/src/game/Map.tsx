import * as React from "react";
import * as R from "ramda";
import styled from "../styled-components";
import * as Action from "./action";
import Ship from "./Ship";
import * as UserState from "./user-state";
import Bullet from "./Bullet";
import { BulletData } from "./Bullet";

import { Channel, Socket } from "phoenix";
import axios from "axios";

interface MapState {
  userId?: string;
  token?: string;
  fps?: number;
  game: {
    users: { [userId: string]: UserState.t };
    bullets: BulletData[];
  };
}

class Map extends React.Component<{}, MapState> {
  state: MapState = {
    game: {
      bullets: [],
      users: {}
    }
  };
  channel: Channel;

  handleKeyDown = ({ key }: KeyboardEvent): void => {
    this.dispatch({
      data: { key, event: "up" },
      type: "key_change"
    });
  };

  handleKeyUp = ({ key }: KeyboardEvent): void => {
    this.dispatch({
      data: { key, event: "down" },
      type: "key_change"
    });
  };

  componentDidMount = async () => {
    await this.connect();

    document.addEventListener("keydown", this.handleKeyDown, false);
    document.addEventListener("keyup", this.handleKeyUp, false);

    this.dispatch({
      data: {},
      type: "new_game"
    });
  };

  componentWillUnmount = () => {
    document.removeEventListener("keydown", this.handleKeyDown, false);
    document.removeEventListener("keyup", this.handleKeyUp, false);
  };

  render() {
    const { fps, game } = this.state;
    return (
      <MapBackground>
        {mapValues(
          user => <Ship fps={fps} key={user.ship.id} ship={user.ship} />,
          game.users
        )}
        {game.bullets.map(bullet => (
          <Bullet key={bullet.id} fps={fps} bullet={bullet} />
        ))}
      </MapBackground>
    );
  }

  private connect = async () => {
    const { data } = await axios.post("http://localhost:4000/api/users");

    const { token, id: userId } = data;

    const socket = new Socket("ws://localhost:4000/socket", {
      params: { token }
    });
    socket.connect();

    this.channel = socket.channel(`store:${userId}`, {});
    this.setState({ userId, token });

    this.channel.join().receive("ok", response => {
      // tslint:disable:no-console
      console.log("Joined successfully", response);
    });

    this.channel.on("store", store => {
      this.setState(store);
    });
  };

  private dispatch = <T extends any>(action: Action.t<T>) => {
    this.channel.push(action.type, action.data);
  };
}

const mapValues = <T extends object>(f: ((value: any) => any), obj: T) =>
  R.pipe(
    R.values,
    R.map(f)
  )(obj);

const MapBackground = styled.div`
  width: 100vw;
  height: 100vh;
  background: blue;
`;

export default Map;
