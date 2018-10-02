import "react";
import styled from "../styled-components";

import * as Position from "./position";

import noSailSprite from "../img/no-sail.png";
import oneSailSprite from "../img/one-sail.png";
import twoSailSprite from "../img/two-sail.png";
import threeSailSprite from "../img/three-sail.png";

export interface ShipData {
  id: string;
  maxSpeed: number;
  position: Position.t;
}

export interface ShipProps {
  fps?: number;
  maxX?: number;
  maxY?: number;
  ship: ShipData;
}

const Ship = styled("div").attrs<ShipProps>({
  style: ({ fps, maxX, maxY, ship: { maxSpeed, position } }: ShipProps) => {
    const sprite = sailSprite(maxSpeed, position.velocity);
    return {
      backgroundImage: `url(${sprite})`,
      transform:
        maxX &&
        maxY &&
        `${Position.translate(maxX, maxY, position)} ${Position.rotate(
          position
        )}`,
      transition: fps ? `${1 / fps}s linear` : "none"
    };
  }
})`
  width: 40px;
  height: 50px;
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
  position: absolute;
`;

const sailSprite = (maxSpeed: number | undefined, speed: number) => {
  const velocity = Math.abs(speed);
  if (!maxSpeed || velocity === 0) {
    return noSailSprite;
  }

  if (velocity < maxSpeed / 2) {
    return oneSailSprite;
  }

  if (velocity < maxSpeed) {
    return twoSailSprite;
  }

  return threeSailSprite;
};

export default Ship;
