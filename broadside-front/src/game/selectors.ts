import * as R from "ramda";

import { Store } from "../reducers";
import { ShipData } from "./Ship";
import * as Score from "./score";

export const getShips = (state: Store): ShipData[] => state.game.ships;

export const isPlaying = (state: Store): boolean => {
  const userId = state.menu.userId;
  const ships = state.game.ships;
  return R.any(R.propEq("id", userId), ships);
};

export const getScores = (state: Store): Score.t => state.game.score;
