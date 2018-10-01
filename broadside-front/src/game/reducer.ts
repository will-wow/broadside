import { BulletData } from "./Bullet";
import { Action } from "../actions";

import * as MenuActions from "../menu/actions";
import { ShipData } from "./Ship";

export interface t {
  gameId?: string;
  fps?: number;
  ships: ShipData[];
  bullets: BulletData[];
}

const initialState = {
  bullets: [],
  ships: []
};

export const reducer = (state: t = initialState, action: Action): t => {
  switch (action.type) {
    case MenuActions.TypeKeys.NEW_GAME_SUCCESS: {
      return { ...state, gameId: action.data.gameId };
    }
    default: {
      return state;
    }
  }
};
