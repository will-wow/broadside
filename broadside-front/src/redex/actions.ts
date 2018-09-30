import * as Action from "./action";
import { Channel } from "phoenix";

export const REDEX_DEFER_ACTION = "redex:redex:defer-action";
export const REDEX_DEFERRED_ACTIONS_CONSUMED =
  "redex:redex:deferred-actions-consumed";
export const REDEX_LOGIN = "redex:redex:login";
export const REDEX_CONNECT = "redex:redex:connect";

export const onDeferAction = (action: Action.t): Action.t => ({
  data: action,
  type: REDEX_DEFER_ACTION
});

export const onDeferredActionsConsumed = () => ({
  type: REDEX_DEFERRED_ACTIONS_CONSUMED
});

export const onLogin = (data: { userId: string; token: string }): Action.t => ({
  data,
  type: REDEX_LOGIN
});

export const onConnect = (channel: Channel): Action.t => ({
  data: channel,
  type: REDEX_CONNECT
});

export const onIncomingStore = (reducer: string, state: any) => ({
  data: state,
  type: `redex:${reducer}`
});
