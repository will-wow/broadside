import { Store } from "./reducers";

import Menu from "./menu/Menu";
import Map from "./game/Map";

export const route = (store: Store): any => (store.game.gameId ? Map : Menu);
