import "react";
import styled from "../styled-components";

export interface ReloadingProps {
  reloading: number;
}

const Reloading = styled.div`
  background: red;
  width: 40px;
  height: 10px;
  position: absolute;
  &:after {
    content: " ";
    background: green;
    width: ${({ reloading }: ReloadingProps) => reloading * 100}%;
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
  }
`;

export default Reloading;
