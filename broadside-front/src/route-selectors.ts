import { Store } from "./reducers";

import Menu from "./menu/Menu";
import Game from "./game/Game";

export const route = (store: Store): any => (store.game.gameId ? Game : Menu);
