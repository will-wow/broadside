import "react";
import styled from "../styled-components";

import * as Position from "./position";

interface ShipProps {
  shipPosition: Position.t;
}

const Ship = styled("div").attrs<ShipProps>({
  style: ({ shipPosition }: ShipProps) => ({
    left: px(shipPosition.x),
    top: px(shipPosition.y),
    transform: rotate(shipPosition.direction)
  })
})`
  width: 10px;
  height: 30px;
  background: brown;
  position: absolute;
`;

const postfix = (post: string) => (value: any): string => `${value}${post}`;

const px = postfix("px");
const rotate = (degrees: number): string => `rotate(${degrees}deg)`;

export default Ship;
