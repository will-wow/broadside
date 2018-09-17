import "react";
import styled from "../styled-components";

import * as Position from "./position";

interface ShipProps {
  shipPosition: Position.t;
}

const Ship = styled<ShipProps, "div">("div")`
  width: 10px;
  height: 30px;
  background: brown;
  position: absolute;
  top: ${({ shipPosition }) => px(shipPosition.y)};
  left: ${({ shipPosition }) => px(shipPosition.x)};
  transform: ${({ shipPosition }) => rotate(shipPosition.direction)};
`;

const postfix = (post: string) => (value: any): string => `${value}${post}`;

const px = postfix("px");
const rotate = (degrees: number): string => `rotate(${degrees}deg)`;

export default Ship;
