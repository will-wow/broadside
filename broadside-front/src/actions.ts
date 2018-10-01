import * as MenuActions from "./menu/actions";
import * as GameActions from "./game/actions";

export type Action = MenuActions.Action | GameActions.Action;
