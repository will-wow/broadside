import "react";
import styled from "../styled-components";

import * as Position from "./position";

interface ShipProps {
  shipPosition: Position.t;
}

const Ship = styled("div").attrs<ShipProps>({
  style: ({ shipPosition: { x, y, heading } }: ShipProps) => ({
    transform: `${translate(x, y)} ${rotate(heading)}`
  })
})`
  width: 10px;
  height: 30px;
  background: brown;
`;

const postfix = (post: string) => (value: any): string => `${value}${post}`;

const px = postfix("px");
const translate = (x: number, y: number): string =>
  `translate(${px(x)}, ${px(y)})`;
const rotate = (degrees: number): string => `rotate(${degrees + 90}deg)`;

export default Ship;
