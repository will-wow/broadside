import { TypeKeys, Action } from "./actions";

export interface t {
  games: string[];
  userId?: string;
}

const initialState = {
  games: []
};

export const reducer = (state: t = initialState, action: Action): t => {
  switch (action.type) {
    case TypeKeys.LOGIN: {
      return { ...state, userId: action.data.userId };
    }
    case TypeKeys.GAME_LIST: {
      return { ...state, games: action.data.games };
    }
    case TypeKeys.GAME_STARTED: {
      const games = [...state.games, action.data.gameId];

      return { ...state, games };
    }
    case TypeKeys.NEW_GAME_SUCCESS: {
      // TODO
      return state;
    }
    default: {
      return state;
    }
  }
};
