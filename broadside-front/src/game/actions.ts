import * as RedexAction from "../redex/action";
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
    fps?: number;
    ships: ShipData[];
    bullets: BulletData[];
  };
}

interface KeyChangeAction extends RedexAction.ChannelAction {
  type: TypeKeys.KEY_CHANGE;
  data: {
    event: "down" | "up";
    key: string;
  };
}

export const eventsToActions = {
  game_state: TypeKeys.GAME_STATE,
  key_change: TypeKeys.KEY_CHANGE
};

export const onKeyChange = RedexAction.channelAction<KeyChangeAction>(
  TypeKeys.KEY_CHANGE
);
