import "react";
import styled from "../styled-components";

import * as Position from "./position";

import noSailSprite from "../img/no-sail.png";
import threeSailSprite from "../img/three-sail.png";

interface ShipProps {
  shipPosition: Position.t;
}

const Ship = styled("div").attrs<ShipProps>({
  style: ({ shipPosition: { x, y, heading, velocity } }: ShipProps) => {
    const sprite = velocity === 0 ? noSailSprite : threeSailSprite;
    return {
      backgroundImage: `url(${sprite})`,
      transform: `${translate(x, y)} ${rotate(heading)}`
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

export default Ship;
