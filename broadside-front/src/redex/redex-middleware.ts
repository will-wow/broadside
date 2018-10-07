import Channels from "./channels-service";
import { Middleware, MiddlewareAPI, Dispatch } from "redux";
import * as Action from "./action";

import * as RedexActions from "./actions";

interface RedexConfig {
  socketEndpoint: string;
}

export default (config: RedexConfig): Middleware => api => next => {
  return (action: Action.FSA | Action.AnyRedexAction): Action.FSA | null => {
    if (Action.isRedexAction(action)) {
      return handleRedexAction(config, api, next, action);
    }

    return next(action);
  };
};

const handleRedexAction = (
  config: RedexConfig,
  api: MiddlewareAPI,
  next: Dispatch,
  action: Action.AnyRedexAction
): Action.FSA => {
  const channels = new Channels(config.socketEndpoint, api.dispatch);

  switch (action.redex.type) {
    case Action.RedexActionType.SocketJoin: {
      const socketPayload = action.redex.data;

      channels.openSocket(socketPayload);

      return next(action);
    }

    case Action.RedexActionType.ChannelJoin: {
      const {
        data,
        redex: {
          data: { topic, eventsToActions }
        }
      } = action;

      channels.connectToChannel(topic, eventsToActions, data);

      return next(action);
    }

    case Action.RedexActionType.ChannelPush: {
      if (channels.isChannelReady(action)) {
        // Send the action to the server, and redux.
        channels.sendMessage(action);
        return next(action);
      } else {
        // Defer the action until the channel is open.
        return api.dispatch(RedexActions.onDeferAction(action));
      }
    }

    default: {
      return next(action);
    }
  }
};
