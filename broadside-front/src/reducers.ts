import { combineReducers } from "redux";

import * as GameReducer from "./game/reducer";
import * as MenuReducer from "./menu/reducer";
import * as RedexReducer from "./redex/reducer";

export interface Store {
  game: GameReducer.t;
  menu: MenuReducer.t;
  redex: RedexReducer.t;
}

export default combineReducers({
  game: GameReducer.reducer,
  menu: MenuReducer.reducer,
  redex: RedexReducer.reducer
});
