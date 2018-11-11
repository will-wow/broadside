import * as React from "react";
import * as R from "ramda";
import { connect } from "react-redux";

import styled from "../styled-components";
import { Store } from "../reducers";
import * as GameSelectors from "./selectors";

import * as Score from "./score";

import * as Text from "../styles/text";
import * as Colors from "../styles/colors";

interface ScoreCardProps {
  scores: Score.t;
  userId: string;
}

const ScoreCard: React.SFC<ScoreCardProps> = ({ scores, userId }) => (
  <Hud>
    <Text.SectionTitle>Scores</Text.SectionTitle>
    {R.map(([scoreUserId, score]: [string, number]) => (
      <UserScore key={scoreUserId}>
        <UserScoreUser>
          {userId === scoreUserId ? "Me" : scoreUserId}
        </UserScoreUser>: {score}
      </UserScore>
    ))(scores)}
  </Hud>
);

const Hud = styled.div`
  background: ${Colors.paper};
  color: ${Colors.pencil};
  font: "sans-serif";
  opacity: 0.5;
  padding: 4px;
  position: absolute;
  right: 0;
  top: 0;
`;

const UserScore = styled.div``;

const UserScoreUser = styled.span`
  font-weight: bold;
`;

export const mapStateToProps = (state: Store): Partial<ScoreCardProps> => {
  return {
    scores: GameSelectors.getScores(state),
    userId: state.menu.userId
  };
};

const connectedComponent = connect(mapStateToProps)(ScoreCard);

export default connectedComponent;

export { ScoreCard };
