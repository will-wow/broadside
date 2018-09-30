import * as R from "ramda";

import { Store } from "./reducers";

import Menu from "./menu/Menu";
import Map from "./game/Map";

export const route = (store: Store): any =>
  keyCount(store.game.users) === 0 ? Menu : Map;

const keyCount: (x: object) => number = R.pipe(
  R.keys,
  R.length
);
