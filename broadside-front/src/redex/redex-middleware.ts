import Channels from "./channels-service";
import { Middleware, MiddlewareAPI, Dispatch } from "redux";
import * as Action from "./action";
import { FSA } from "./action";

import * as RedexActions from "./actions";

interface RedexConfig {
  socketEndpoint: string;
}

export default (config: RedexConfig): Middleware => api => next => {
  const channels: Channels = new Channels(config.socketEndpoint, api.dispatch);

  return (action: FSA | Action.AnyRedexAction): FSA | null => {
    if (Action.isRedexAction(action)) {
      return handleRedexAction(channels, config, api, next, action);
    }

    return next(action);
  };
};

const handleRedexAction = (
  channels: Channels,
  config: RedexConfig,
  api: MiddlewareAPI,
  next: Dispatch,
  action: Action.AnyRedexAction
): FSA => {
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
      const pushAction = action as Action.ChannelPushAction<FSA>;

      if (channels.isChannelReady(pushAction)) {
        // Send the action to the server, and redux.
        channels.sendMessage(pushAction);
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
