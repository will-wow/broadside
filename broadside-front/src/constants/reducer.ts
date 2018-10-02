import * as ConstantActions from "./actions";
import { Action } from "../actions";

export interface t {
  fps?: number;
  maxX?: number;
  maxY?: number;
}

const initialState = {};

export const reducer = (state: t = initialState, action: Action): t => {
  switch (action.type) {
    case ConstantActions.TypeKeys.GET_CONSTANTS_SUCCESS: {
      // tslint:disable
      console.log("success", action);
      return action.data;
    }
    default: {
      return state;
    }
  }
};
