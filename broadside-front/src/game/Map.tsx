import * as React from "react";
import styled from "../styled-components";
import Ship from "./Ship";

import * as Position from "./position";
import * as KeysDown from "./keys-down";
import { Channel, Socket } from "phoenix";
import axios from "axios";

interface MapState {
  userId?: string;
  token?: string;
  fps?: number;
  maxSpeed?: number;
  shipPosition: Position.t;
  keysDown: KeysDown.t;
}

class Map extends React.Component<{}, MapState> {
  state: MapState = {
    keysDown: {},
    shipPosition: {
      heading: 90,
      velocity: 0,
      x: 20,
      y: 20
    }
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
    const { fps, maxSpeed, shipPosition } = this.state;
    return (
      <MapBackground>
        <Ship fps={fps} maxSpeed={maxSpeed} shipPosition={shipPosition} />
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
