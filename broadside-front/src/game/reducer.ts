import * as MenuActions from "../menu/actions";
import * as GameActions from "./actions";
import * as Score from "./score";
import { Action } from "../actions";

import { BulletData } from "./Bullet";
import { ShipData } from "../ships/Ship";

export interface t {
  gameId?: string;
  score: Score.t;
  ships: ShipData[];
  bullets: BulletData[];
}

const initialState = {
  bullets: [],
  score: [],
  ships: []
};

export const reducer = (state: t = initialState, action: Action): t => {
  switch (action.type) {
    case GameActions.TypeKeys.GAME_STATE: {
      return { ...state, ...action.data };
    }
    case MenuActions.TypeKeys.JOIN_GAME:
    case MenuActions.TypeKeys.NEW_GAME_SUCCESS: {
      return { ...state, gameId: action.data.gameId };
    }
    default: {
      return state;
    }
  }
};
