import * as R from "ramda";
import * as Action from "./action";

import { Action as RedexAction, TypeKeys } from "./actions";

export interface t {
  token?: string;
  deferredActions: DeferredActions;
}

type DeferredActionArray = Array<Action.ChannelPushAction<any, any>>;

interface DeferredActions {
  [topic: string]: DeferredActionArray;
}

const initialState: t = {
  deferredActions: {}
};

export const reducer = (state: t = initialState, action: RedexAction): t => {
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
