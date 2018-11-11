import "react";
import styled from "../styled-components";

import * as Position from "../game/position";

import { ShipData } from "./Ship";

import noSailSprite from "../img/no-sail.png";
import oneSailSprite from "../img/one-sail.png";
import twoSailSprite from "../img/two-sail.png";
import threeSailSprite from "../img/three-sail.png";

export interface ShipSpriteProps {
  ship: ShipData;
  fps?: number;
  isUser: boolean;
}

const ShipSprite = styled("div").attrs<ShipSpriteProps>({
  style: ({ isUser, fps, ship: { position } }: ShipSpriteProps) => {
    const sprite = sailSprite(position.maxVelocity, position.velocity);
    return {
      backgroundImage: `url(${sprite})`,
      opacity: isUser ? 1 : 0.7,
      transform: `${Position.rotate(position)}`,
      transition: fps ? `${1 / fps}s linear` : "none"
    };
  }
})`
  width: 40px;
  height: 50px;
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
`;

const sailSprite = (maxVelocity: number | undefined, speed: number) => {
  const velocity = Math.abs(speed);
  if (!maxVelocity || velocity === 0) {
    return noSailSprite;
  }

  if (velocity < maxVelocity / 2) {
    return oneSailSprite;
  }

  if (velocity < maxVelocity) {
    return twoSailSprite;
  }

  return threeSailSprite;
};

export default ShipSprite;
