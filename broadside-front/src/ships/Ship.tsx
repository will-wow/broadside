import * as React from "react";
import styled from "../styled-components";

import * as Position from "../game/position";

import Reloading from "./Reloading";
import ShipSprite from "./ShipSprite";

export interface ShipData {
  id: string;
  position: Position.t;
  health: number;
  reloading: number;
}

export interface ShipProps {
  fps?: number;
  maxX?: number;
  maxY?: number;
  ship: ShipData;
  userId: string;
}

const Ship: React.SFC<ShipProps> = props => {
  const { ship, userId, fps } = props;
  const { id, reloading } = ship;

  const isUser = id === userId;
  return (
    <StyledShip {...props}>
      <ShipSprite ship={ship} isUser={isUser} fps={fps} />

      {isUser && Boolean(reloading) && <Reloading reloading={reloading} />}
    </StyledShip>
  );
};

const StyledShip = styled("div").attrs<ShipProps>({
  style: ({ fps, maxX, maxY, ship: { position } }: ShipProps) => {
    return {
      transform: maxX && maxY && `${Position.translate(maxX, maxY, position)}`,
      transition: fps ? `${1 / fps}s linear` : "none"
    };
  }
})`
  position: absolute;
`;

export default Ship;
