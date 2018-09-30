import * as Action from "./action";

import { REDEX_CONNECT, REDEX_DEFER_ACTION, REDEX_LOGIN } from "./actions";

export interface t {
  token?: string;
  deferredActions: Action.t[];
}

const initialState: t = {
  deferredActions: []
};

export const reducer = (state: t = initialState, action: Action.t): t => {
  switch (action.type) {
    case REDEX_LOGIN: {
      return { ...state, ...action.data };
    }
    case REDEX_DEFER_ACTION: {
      let { deferredActions } = state;

      deferredActions = [...deferredActions, action.data];

      return { ...state, deferredActions };
    }
    case REDEX_CONNECT: {
      return { ...state, channel: action.data };
    }
    default: {
      return state;
    }
  }
};
