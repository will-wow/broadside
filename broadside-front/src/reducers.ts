import { combineReducers } from "redux";

import * as GameReducer from "./game/reducer";
import * as MenuReducer from "./menu/reducer";
import * as RedexReducer from "./redex/reducer";
import * as ConstantsReducer from "./constants/reducer";

export interface Store {
  game: GameReducer.t;
  menu: MenuReducer.t;
  redex: RedexReducer.t;
  constants: ConstantsReducer.t;
}

export default combineReducers({
  constants: ConstantsReducer.reducer,
  game: GameReducer.reducer,
  menu: MenuReducer.reducer,
  redex: RedexReducer.reducer
});
