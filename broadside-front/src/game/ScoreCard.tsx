import * as React from "react";
import { connect } from "react-redux";

import styled from "../styled-components";
import { Store } from "../reducers";
import * as GameSelectors from "./selectors";

import * as Score from "./score";

interface ScoreCardProps {
  scores: Score.t;
}

const ScoreCard: React.SFC<ScoreCardProps> = ({ scores }) => (
  <Hud>scores</Hud>
);

const Hud = styled.div`
  position: absolute;
  top: 0;
  right: 0;
  background: white;
  opacity: 0.5;
  color: black;
`;

export const mapStateToProps = (state: Store): Partial<ScoreCardProps> => {
  return {
    scores: GameSelectors.getScores(state)
  };
};

const connectedComponent = connect(mapStateToProps)(ScoreCard);

export default connectedComponent;

export { ScoreCard };
