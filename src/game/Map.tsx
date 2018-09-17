import * as React from "react";
import styled from "../styled-components";
import Ship from "./Ship";

interface MapProps {
  className?: string;
}

const Map: React.SFC<MapProps> = ({ className }) => (
  <div className={className}>
    <Ship />
  </div>
);

const StyledMap = styled(Map)`
  width: '100vw',
  height: '100vh',
  background: 'blue'
`;

export default StyledMap;
