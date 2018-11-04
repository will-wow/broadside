import * as R from "ramda";
import { FSA } from "./action";
import * as RedexAction from "./action";

import { Action, TypeKeys } from "./actions";

export interface t {
  token?: string;
  deferredActions: DeferredActions;
}

type DeferredActionArray = Array<RedexAction.ChannelPushAction<FSA>>;

interface DeferredActions {
  [topic: string]: DeferredActionArray;
}

const initialState: t = {
  deferredActions: {}
};

export const reducer = (state: t = initialState, action: Action): t => {
  switch (action.type) {
    case TypeKeys.REDEX_DEFER_ACTION: {
      const deferredAction = action.data;
      const topic = deferredAction.redex.data.topic;

      const { deferredActions } = state;

      const topicActions: DeferredActionArray = R.append(
        deferredAction,
        deferredActions[topic] || []
      );

      return R.assocPath(["deferredActions", topic], topicActions, state);
    }
    case TypeKeys.REDEX_CHANNEL_JOIN_SUCCESS: {
      const topic = action.data.topic;
      return R.assocPath(["deferredActions", topic], [], state);
    }
    default: {
      return state;
    }
  }
};
