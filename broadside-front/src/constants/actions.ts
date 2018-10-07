import * as RedexAction from "../redex/action";
import * as ConstantsReducer from "./reducer";

export enum TypeKeys {
  GET_CONSTANTS = "constants:get",
  GET_CONSTANTS_SUCCESS = "constants:get:success"
}

export type Action = GetConstantsAction | GetConstantsSuccessAction;

type GetConstantsAction = RedexAction.ChannelPushAction<
  undefined,
  TypeKeys.GET_CONSTANTS
>;

interface GetConstantsSuccessAction {
  type: TypeKeys.GET_CONSTANTS_SUCCESS;
  data: ConstantsReducer.t;
}

// TODO: Nicer wrapper for no-data creators.
export const onGetConstants = RedexAction.channelPushAction<GetConstantsAction>(
  TypeKeys.GET_CONSTANTS
);
