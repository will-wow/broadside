import Channels from "./channels-service";
import { Middleware } from "redux";
import * as Action from "./action";

import * as RedexActions from "./actions";

interface RedexConfig {
  socketEndpoint: string;
}

export default (config: RedexConfig): Middleware => api => next => {
  const channels = new Channels(config.socketEndpoint, api.dispatch);

  return (action: Action.t | Action.ChannelAction): Action.t | null => {
    if (action.type === RedexActions.TypeKeys.REDEX_SOCKET_CONNECT) {
      const data: RedexActions.RedexSocketConnectAction["data"] = action.data;

      channels.openSocket(data.token);

      return next(action);
    }

    if (action.type === RedexActions.TypeKeys.REDEX_CHANNEL_CONNECT) {
      const data: RedexActions.RedexChannelConnectAction["data"] = action.data;

      channels.connectToChannel(data.topic, data.eventsToActions);
    }

    if (Action.isChannelAction(action)) {
      if (channels.isChannelReady(action)) {
        // Send the action to the server, and redux.
        channels.sendMessage(action);
        return next(action);
      } else {
        // Defer the action until the channel is open.
        return api.dispatch(RedexActions.onDeferAction(action));
      }
    }

    return next(action);
  };
};
