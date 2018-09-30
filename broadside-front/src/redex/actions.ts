import * as Action from "./action";
import * as Channels from "./channels-service";

export interface RedexSocketConnectData {
  token: string;
}

export interface RedexChannelConnectData {
  topic: string;
  eventsToActions: Channels.EventsToActions;
}

export interface RedexChannelConnectSuccessData {
  topic: string;
}

export const REDEX_SOCKET_CONNECT = "redex:socket:connect";
export const REDEX_CHANNEL_CONNECT = "redex:channel:connect";
export const REDEX_CHANNEL_CONNECT_SUCCESS = "redex:channel:connect:success";
export const REDEX_DEFER_ACTION = "redex:defer-action";
export const REDEX_DEFERRED_ACTIONS_CONSUMED =
  "redex:deferred-actions-consumed";

export const onSocketConnect = Action.withData<RedexSocketConnectData>(
  REDEX_SOCKET_CONNECT
);

export const onChannelConnect = Action.withData<RedexChannelConnectData>(
  REDEX_CHANNEL_CONNECT
);

export const onDeferAction = Action.withData<Action.ChannelAction>(
  REDEX_DEFER_ACTION
);

export const onChannelConnectSuccess = Action.withData<
  RedexChannelConnectSuccessData
>(REDEX_DEFER_ACTION);
