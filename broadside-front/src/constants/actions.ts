import * as RedexAction from "../redex/action";
import * as ConstantsReducer from "./reducer";

export enum TypeKeys {
  GET_CONSTANTS = "constants:get",
  GET_CONSTANTS_SUCCESS = "constants:get:success"
}

export type Action = GetConstantsAction | GetConstantsSuccessAction;

interface GetConstantsAction extends RedexAction.ChannelAction {
  type: TypeKeys.GET_CONSTANTS;
}

interface GetConstantsSuccessAction {
  type: TypeKeys.GET_CONSTANTS_SUCCESS;
  data: ConstantsReducer.t;
}

export const onGetConstants = RedexAction.channelAction<GetConstantsAction>(
  TypeKeys.GET_CONSTANTS
);
