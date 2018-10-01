import { Action } from "redux";

export interface t<T = any> extends Action {
  type: string;
  data?: T;
}

export interface ChannelAction<T = any> extends t<T> {
  topic: string;
  redex: "channelAction";
}

export function channelAction<T extends ChannelAction>(
  type: T["type"],
  topic: T["topic"]
): (data?: T["data"]) => T;
export function channelAction<T extends ChannelAction>(
  type: T["type"]
): (topic: T["topic"], data?: T["data"]) => T;
export function channelAction<T extends ChannelAction>(
  type: T["type"],
  topic?: T["topic"]
) {
  if (topic) {
    return (data: T["data"]) => ({
      data,
      redex: "channelAction",
      topic,
      type
    });
  }

  return (topic: T["topic"], data: T["data"]) => ({
    data,
    redex: "channelAction",
    topic,
    type
  });
}

export const withData = <T extends t>(type: T["type"]) => (
  data: T["data"]
): T =>
  ({
    data,
    type
  } as T);

export const noData = <T extends t>(type: T["type"]) => (): T =>
  ({
    type
  } as T);

export const isChannelAction = (
  action: t | ChannelAction
): action is ChannelAction =>
  (action as ChannelAction).redex === "channelAction";
