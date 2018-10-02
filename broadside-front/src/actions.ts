import * as MenuActions from "./menu/actions";
import * as GameActions from "./game/actions";
import * as ConstantsActions from "./constants/actions";

export type Action =
  | MenuActions.Action
  | GameActions.Action
  | ConstantsActions.Action;
