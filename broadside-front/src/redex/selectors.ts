import * as RedexReducer from "./reducer";

interface RedexStore {
  redex: RedexReducer.t;
}

export const getChannel = (state: RedexStore) => state.redex.channel;

export const getDeferredActions = (state: RedexStore) =>
  state.redex.deferredActions;
