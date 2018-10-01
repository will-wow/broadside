import * as R from "ramda";
import * as Action from "./action";

import { Action as RedexAction, TypeKeys } from "./actions";

export interface t {
  token?: string;
  deferredActions: DeferredActions;
}

interface DeferredActions {
  [topic: string]: Action.ChannelAction[];
}

const initialState: t = {
  deferredActions: {}
};

export const reducer = (state: t = initialState, action: RedexAction): t => {
  switch (action.type) {
    case TypeKeys.REDEX_DEFER_ACTION: {
      const topic = action.data.topic;
      const { deferredActions } = state;

      const actions = deferredActions[topic] || [];

      return R.assocPath(["deferredActions", topic], actions, state);
    }
    case TypeKeys.REDEX_CHANNEL_CONNECT_SUCCESS: {
      const topic = action.data.topic;
      return R.assocPath(["deferredActions", topic], [], state);
    }
    default: {
      return state;
    }
  }
};
