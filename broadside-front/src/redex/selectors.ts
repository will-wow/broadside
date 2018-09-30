import * as RedexReducer from "./reducer";

interface RedexStore {
  redex: RedexReducer.t;
}

export const getDeferredActions = (state: RedexStore) =>
  state.redex.deferredActions;
