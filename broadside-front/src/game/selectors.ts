import * as R from "ramda";

import { Store } from "../reducers";
import { ShipData } from "./Ship";

export const getShips = (state: Store): ShipData[] => state.game.ships;

export const isPlaying = (state: Store): boolean => {
  const userId = state.menu.userId;
  const ships = state.game.ships;
  return R.any(R.propEq("id", userId), ships);
};
