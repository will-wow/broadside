import * as R from "ramda";
import { combineReducers } from "redux";
import * as Action from "./action";
import * as RedexReducer from "./reducer";
import * as Utils from "../lib/utils";

export interface RedexReducerConfig<T> {
  name: string;
  initialState: T;
}

export interface Store {
  redex: RedexReducer.t;
  [key: string]: any;
}

const redexReducer = <T>({ initialState, name }: RedexReducerConfig<T>) => (
  state: T = initialState,
  action: Action.FSA
): T => {
  switch (action.type) {
    case `redex:${name}`: {
      return action.data;
    }
    default: {
      return state;
    }
  }
};

export const redexReducers = <T extends Store>(
  reducers: Array<RedexReducerConfig<Utils.ValueOf<T>>>
) =>
  R.pipe(
    R.map((reducer: RedexReducerConfig<Utils.ValueOf<T>>) => [
      reducer.name,
      redexReducer(reducer)
    ]),
    R.fromPairs,
    R.merge({ redex: RedexReducer.reducer }),
    combineReducers
  )(reducers);
