import * as React from "react";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";

import styled from "../styled-components";
import { Store } from "../reducers";
import * as GameSelectors from "./selectors";

import * as Score from "./score";

interface ScoreCardProps {
  scores: Score.t;
}

const ScoreCard: React.SFC<ScoreCardProps> = ({ scores }) => <Hud>h</Hud>;

const Hud = styled.div`
  position: absolute;
  top: 0;
  right: 0;
  background: white;
  opacity: 0.5;
  color: black;
`;

export const mapStateToProps = (state: Store): Partial <ScoreCardProps> => {
  return {
    scores: GameSelectors.getScores(state)
  };
};

export const mapDispatchToProps = (dispatch: Dispatch) =>
  bindActionCreators(
    {
      onChannelConnect,
      onKeyChange
    },
    dispatch
  );

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(Game);

export default connectedComponent;

export { Game };
