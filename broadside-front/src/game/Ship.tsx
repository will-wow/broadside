import "react";
import styled from "../styled-components";

import * as Position from "./position";

import noSailSprite from "../img/no-sail.png";
import oneSailSprite from "../img/one-sail.png";
import twoSailSprite from "../img/two-sail.png";
import threeSailSprite from "../img/three-sail.png";

interface ShipProps {
  fps?: number;
  maxSpeed?: number;
  shipPosition: Position.t;
}

const Ship = styled("div").attrs<ShipProps>({
  style: ({
    fps,
    maxSpeed,
    shipPosition: { x, y, heading, velocity }
  }: ShipProps) => {
    const sprite = sailSprite(maxSpeed, velocity);
    return {
      backgroundImage: `url(${sprite})`,
      transform: `${translate(x, y)} ${rotate(heading)}`,
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

const postfix = (post: string) => (value: any): string => `${value}${post}`;

const px = postfix("px");
const translate = (x: number, y: number): string =>
  `translate(${px(x)}, ${px(y)})`;
const rotate = (degrees: number): string => `rotate(${degrees + 90}deg)`;

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
