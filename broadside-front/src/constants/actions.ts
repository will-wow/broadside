import * as RedexAction from "../redex/action";
import * as ConstantsReducer from "./reducer";

export enum TypeKeys {
  GET_CONSTANTS = "constants:get",
  GET_CONSTANTS_SUCCESS = "constants:get:success"
}

export type Action = GetConstantsAction | GetConstantsSuccessAction;

interface GetConstantsAction {
  data: undefined;
  type: TypeKeys.GET_CONSTANTS;
}

interface GetConstantsSuccessAction {
  data: ConstantsReducer.t;
  type: TypeKeys.GET_CONSTANTS_SUCCESS;
}

export const onGetConstants = (): GetConstantsAction =>
  RedexAction.channelAction<GetConstantsAction>(
    { topic: "" },
    {
      data: undefined,
      type: TypeKeys.GET_CONSTANTS
    }
  );
