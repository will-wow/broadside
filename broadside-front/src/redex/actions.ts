import * as Action from "./action";

export enum TypeKeys {
  REDEX_CHANNEL_JOIN = "redex:channel:join",
  REDEX_CHANNEL_JOIN_SUCCESS = "redex:channel:join:success",
  REDEX_DEFER_ACTION = "redex:action:defer",
  REDEX_SOCKET_JOIN = "redex:socket:join",
  OTHER_ACTION = "__other__"
}

export type Action =
  | RedexDeferAction
  | RedexChannelConnectSuccessAction
  | Action.ChannelJoinAction
  | Action.SocketJoinAction;

export type RedexChannelConnectSuccessAction = Action.FSA<
  {
    topic: string;
  },
  TypeKeys.REDEX_CHANNEL_JOIN_SUCCESS
>;

export type RedexDeferAction = Action.FSA<
  Action.ChannelPushAction<any, any>,
  TypeKeys.REDEX_DEFER_ACTION
>;

export const onChannelConnectSuccess = Action.withData<
  RedexChannelConnectSuccessAction
>(TypeKeys.REDEX_CHANNEL_JOIN_SUCCESS);

export const onDeferAction = Action.withData<RedexDeferAction>(
  TypeKeys.REDEX_DEFER_ACTION
);
