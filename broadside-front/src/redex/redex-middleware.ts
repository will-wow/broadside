import * as R from "ramda";
import axios from "axios";
import { Channel, Socket } from "phoenix";
import { Middleware, MiddlewareAPI, Dispatch } from "redux";
import { Store } from "./reducers";
import * as Action from "./action";
import * as Utils from "../utils";

import {
  onConnect,
  onDeferAction,
  onDeferredActionsConsumed,
  onIncomingStore,
  onLogin,
  REDEX_CONNECT
} from "./actions";

import { getChannel, getDeferredActions } from "./selectors";

interface RedexConfig {
  tokenEndpoint: string;
  socketEndpoint: string;
}

export default (config: RedexConfig): Middleware => api => next => {
  setup(config, api);

  return (action: Action.t): Action.t | null => {
    if (action.type === REDEX_CONNECT) {
      next(action);
      dispatchDeferredActions(api);
      return null;
    }

    if (isRedexAction(action)) {
      return next(action);
    }

    const store = api.getState();
    const channel = getChannel(store);

    next(action);
    if (channel) {
      dispatchOutgoingAction(channel, action);
    } else {
      api.dispatch(onDeferAction(action));
    }

    return null;
  };
};

const isRedexAction = (action: Action.t): boolean =>
  action.type.startsWith("redex:");

const setup = async <S extends Store>(
  config: RedexConfig,
  api: MiddlewareAPI
): Promise<void> => {
  const { data } = await axios.post(config.tokenEndpoint);

  const { token, id: userId } = data;

  api.dispatch(onLogin({ token, userId }));

  const socket = new Socket(config.socketEndpoint, {
    params: { token }
  });
  socket.connect();

  const channel = socket.channel(`store:${userId}`, {});

  channel.join().receive("ok", _ => {
    // tslint:disable:no-console
    console.log("Joined redex channel");

    api.dispatch(onConnect(channel));
  });

  const dispatchToReducers = dispatchIncomingActions(api.dispatch);

  channel.on("store", (store: Partial<S>) => dispatchToReducers(store));
};

const dispatchDeferredActions = <S extends Store>(api: MiddlewareAPI) => {
  const store: S = api.getState();

  R.pipe(
    getDeferredActions,
    Utils.log("deferred"),
    R.forEach(api.dispatch)
  )(store);

  api.dispatch(onDeferredActionsConsumed());
};

const dispatchOutgoingAction = (channel: Channel, action: Action.t) =>
  channel.push(action.type, action.data);

const dispatchIncomingActions = (dispatch: Dispatch) => <S extends Store>(
  store: Partial<S>
) =>
  R.pipe(
    R.toPairs,
    R.map(([reducer, state]) => onIncomingStore(reducer, state)),
    R.forEach(dispatch)
  )(store);
