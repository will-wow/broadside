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

interface KeyChangeAction {
  data: {
    event: "down" | "up";
    key: string;
  };
  type: TypeKeys.KEY_CHANGE;
}

export const eventsToActions = {
  constants: ConstantsActions.TypeKeys.GET_CONSTANTS_SUCCESS,
  game_state: TypeKeys.GAME_STATE,
  key_change: TypeKeys.KEY_CHANGE
};

export const onKeyChange = (
  topic: string,
  {
    key,
    event
  }: {
    key: string;
    event: "up" | "down";
  }
): KeyChangeAction => {
  const action: KeyChangeAction = {
    data: {
      event,
      key
    },
    type: TypeKeys.KEY_CHANGE
  };

  return RedexAction.channelAction({ topic }, action);
};

export const onGameConnect = (gameId: string) =>
  RedexAction.channelJoinAction({
    eventsToActions,
    topic: `game:${gameId}`
  })({ type: "join_lobby", data: undefined });
