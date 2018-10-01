import * as Action from "./action";
import * as Channels from "./channels-service";

export enum TypeKeys {
  REDEX_SOCKET_CONNECT = "redex:socket:connect",
  REDEX_CHANNEL_CONNECT = "redex:channel:connect",
  REDEX_CHANNEL_CONNECT_SUCCESS = "redex:channel:connect:success",
  REDEX_DEFER_ACTION = "redex:defer-action",
  REDEX_DEFERRED_ACTIONS_CONSUMED = "redex:deferred-actions-consumed",
  OTHER_ACTION = "__other__"
}

export type Action =
  | RedexDeferAction
  | RedexSocketConnectAction
  | RedexChannelConnectAction
  | RedexChannelConnectSuccessAction;

export interface RedexSocketConnectAction extends Action.t {
  type: TypeKeys.REDEX_SOCKET_CONNECT;
  data: {
    token: string;
  };
}

export interface RedexChannelConnectAction extends Action.t {
  type: TypeKeys.REDEX_CHANNEL_CONNECT;
  data: {
    topic: string;
    eventsToActions: Channels.EventsToActions;
  };
}

export interface RedexChannelConnectSuccessAction extends Action.t {
  type: TypeKeys.REDEX_CHANNEL_CONNECT_SUCCESS;
  data: {
    topic: string;
  };
}

export interface RedexDeferAction extends Action.t {
  type: TypeKeys.REDEX_DEFER_ACTION;
  data: Action.ChannelAction;
}

export const onSocketConnect = Action.withData<RedexSocketConnectAction>(
  TypeKeys.REDEX_SOCKET_CONNECT
);

export const onChannelConnect = Action.withData<RedexChannelConnectAction>(
  TypeKeys.REDEX_CHANNEL_CONNECT
);

export const onChannelConnectSuccess = Action.withData<
  RedexChannelConnectSuccessAction
>(TypeKeys.REDEX_CHANNEL_CONNECT_SUCCESS);

export const onDeferAction = Action.withData<Action.ChannelAction>(
  TypeKeys.REDEX_DEFER_ACTION
);
