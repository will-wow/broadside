import * as RedexAction from "./action";
import { FSA } from "./action";

export enum TypeKeys {
  REDEX_CHANNEL_JOIN_SUCCESS = "redex:channel:join:success",
  REDEX_DEFER_ACTION = "redex:action:defer",
  OTHER_ACTION = "__other__"
}

export type Action = RedexDeferAction | RedexChannelConnectSuccessAction;

export type RedexChannelConnectSuccessAction = FSA<
  {
    topic: string;
  },
  TypeKeys.REDEX_CHANNEL_JOIN_SUCCESS
>;

export type RedexDeferAction = FSA<
  RedexAction.ChannelPushAction<FSA>,
  TypeKeys.REDEX_DEFER_ACTION
>;

export const onChannelConnectSuccess = (
  topic: string
): RedexChannelConnectSuccessAction => ({
  data: { topic },
  type: TypeKeys.REDEX_CHANNEL_JOIN_SUCCESS
});

export const onDeferAction = (data: any): RedexDeferAction => ({
  data,
  type: TypeKeys.REDEX_DEFER_ACTION
});
