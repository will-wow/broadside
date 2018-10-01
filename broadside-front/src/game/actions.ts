import * as RedexAction from "../redex/action";

export enum TypeKeys {
  KEY_CHANGE = "game:key_change"
}

export type Action = KeyChangeAction;

interface KeyChangeAction extends RedexAction.ChannelAction {
  type: TypeKeys.KEY_CHANGE;
  data: {
    event: "down" | "up";
    key: string;
  };
}

export const eventsToActions = {
  key_change: TypeKeys.KEY_CHANGE
};

export const onKeyChange = RedexAction.channelAction<KeyChangeAction>(
  TypeKeys.KEY_CHANGE
);
