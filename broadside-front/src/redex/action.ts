import { Action } from "redux";

export interface t<T = any> extends Action {
  type: string;
  data?: T;
}

export interface ChannelAction<T = any> extends t<T> {
  topic: string;
  redex: "channelAction";
}

export const channelAction = <T = any>(topic: string, type: string) => (
  data?: T
): ChannelAction<T> => ({
  data,
  redex: "channelAction",
  topic,
  type
});

export const withData = <T>(type: string) => (data: T): t => ({
  data,
  type
});

export const noData = (type: string) => (): t => ({
  type
});

export const isChannelAction = (
  action: t | ChannelAction
): action is ChannelAction =>
  (action as ChannelAction).redex === "channelAction";
