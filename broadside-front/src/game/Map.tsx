import * as React from "react";
import styled from "../styled-components";
import Ship from "./Ship";
import { ShipData } from "./Ship";
import Bullet from "./Bullet";
import { BulletData } from "./Bullet";

import { Channel, Socket } from "phoenix";
import axios from "axios";

interface MapState {
  userId?: string;
  token?: string;
  fps?: number;
  bullets: BulletData[];
  ships: ShipData[];
}

class Map extends React.Component<{}, MapState> {
  state: MapState = {
    bullets: [],
    ships: []
  };
  channel: Channel;

  handleKeyDown = ({ key }: KeyboardEvent): void => {
    this.channel.push("dispatch", { type: "key_down", data: key });
  };

  handleKeyUp = ({ key }: KeyboardEvent): void => {
    this.channel.push("dispatch", { type: "key_up", data: key });
  };

  componentDidMount = () => {
    this.connect();

    document.addEventListener("keydown", this.handleKeyDown, false);
    document.addEventListener("keyup", this.handleKeyUp, false);
  };

  componentWillUnmount = () => {
    document.removeEventListener("keydown", this.handleKeyDown, false);
    document.removeEventListener("keyup", this.handleKeyUp, false);
  };

  render() {
    const { fps, ships, bullets } = this.state;
    return (
      <MapBackground>
        {ships.map(ship => <Ship fps={fps} key={ship.id} ship={ship} />)}
        {bullets.map(bullet => <Bullet key={bullet.id} fps={fps} bullet={bullet} />)}
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
}

const MapBackground = styled.div`
  width: 100vw;
  height: 100vh;
  background: blue;
`;

export default Map;
