import * as RedexAction from "../redex/action";

import * as ConstantsActions from "../constants/actions";

import { BulletData } from "./Bullet";
import { ShipData } from "./Ship";

export enum TypeKeys {
  GAME_STATE = "game:state",
  KEY_CHANGE = "game:key_change"
}

export type Action = GameStateAction | KeyChangeAction;

interface GameStateAction {
  type: TypeKeys.GAME_STATE;
  data: {
    ships: ShipData[];
    bullets: BulletData[];
  };
}

type KeyChangeAction = RedexAction.ChannelPushAction<
  {
    event: "down" | "up";
    key: string;
  },
  TypeKeys.KEY_CHANGE
>;

export const eventsToActions = {
  constants: ConstantsActions.TypeKeys.GET_CONSTANTS_SUCCESS,
  game_state: TypeKeys.GAME_STATE,
  key_change: TypeKeys.KEY_CHANGE
};

// TODO
export const onKeyChange = RedexAction.channelAction<KeyChangeAction>(
  TypeKeys.KEY_CHANGE
);
