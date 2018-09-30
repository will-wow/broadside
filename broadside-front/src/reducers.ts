import * as GameReducer from "./game/reducer";
import * as MenuReducer from "./menu/reducer";
import * as RedexReducers from "./redex/reducers";

export interface Store extends RedexReducers.Store {
  game: GameReducer.t;
  menu: MenuReducer.t;
}

export default RedexReducers.redexReducers<Store>([
  GameReducer.reducer,
  MenuReducer.reducer
]);
