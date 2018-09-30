import * as R from "ramda";

import { Store } from "../reducers";
import { ShipData } from "./Ship";
import * as GameUser from "./game-user";

export const getUsers = (state: Store) => state.game.users;

export const getShips = (state: Store): ShipData[] =>
  R.pipe(
    getUsers,
    R.values,
    R.map(GameUser.getShip)
  )(state);
