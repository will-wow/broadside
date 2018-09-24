import "react";
import styled from "../styled-components";

import * as Position from "./position";

export interface BulletData {
  id: string;
  position: Position.t;
}

export interface BulletProps {
  fps?: number;
  bullet: BulletData;
}

const Bullet = styled("div").attrs<BulletProps>({
  style: ({ fps, bullet: { position } }: BulletProps) => {
    return {
      transform: Position.translate(position),
      transition: fps ? `${1 / fps}s linear` : "none"
    };
  }
})`
  width: 10px;
  height: 10px;
  background-color: gray;
  border-radius: 50;
`;

export default Bullet;
