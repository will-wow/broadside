import * as R from "ramda";
import { Action } from "redux";
import { TypeKeys as RedexTypeKeys } from "./actions";

export interface FSA<Data = undefined, Type = string> extends Action {
  type: Type;
  data: Data;
}

export interface RedexAction<
  RedexType extends RedexActionType,
  Type extends string,
  RedexData,
  Data = undefined
> extends FSA<Data, Type> {
  redex: RedexPayload<RedexType, RedexData>;
}

export type AnyRedexAction = RedexAction<any, any, any, any>;

export type ChannelJoinAction<Data = undefined> = RedexAction<
  RedexActionType.ChannelJoin,
  RedexTypeKeys.REDEX_CHANNEL_JOIN,
  {
    topic: string;
    // TODO
    eventsToActions?: {};
  },
  Data
>;

export type ChannelPushAction<
  Data = undefined,
  Type extends string = string
> = RedexAction<RedexActionType.ChannelPush, Type, ChannelPushActionInfo, Data>;

export type SocketJoinAction<Data = undefined> = RedexAction<
  RedexActionType.SocketJoin,
  RedexTypeKeys.REDEX_SOCKET_JOIN,
  {},
  Data
>;

interface ChannelPushActionInfo {
  topic: string;
  // TODO
  channelEvent?: string;
}

interface RedexPayload<RedexType extends RedexActionType, RedexData> {
  data: RedexData;
  type: RedexType;
}

export enum RedexActionType {
  ChannelJoin = "ChannelJoin",
  ChannelPush = "ChannelPush",
  SocketJoin = "SocketJoin"
}

/**
 * Decorates a standard Action with data to tell redex to
 * send it to a channel.
 * Curried.
 * @param topic - The channel topic to send the payload to.
 * @param action - The action. The payload will be send to the channel.
 */

export function channelAction<Data = any, Type extends string = string>(
  channelInfo: ChannelPushActionInfo
): (action: FSA<Data, Type>) => ChannelPushAction<Data, Type>;
export function channelAction<Data = any, Type extends string = string>(
  channelInfo: ChannelPushActionInfo,
  action: FSA<Data, Type>
): ChannelPushAction<Data, Type>;
export function channelAction<Data = any, Type extends string = string>(
  channelInfo: ChannelPushActionInfo,
  action?: FSA<Data, Type>
) {
  if (action) {
    return R.merge(action, {
      redex: {
        data: channelInfo,
        type: RedexActionType.ChannelPush as RedexActionType.ChannelPush
      }
    });
  } else {
    return (action: FSA<Data, Type>) => channelAction(channelInfo, action);
  }
}

/**
 * Returns an action that will cause Redex to join a channel.
 * Requires an open socket first.
 * @param data - The data to pass to the channel.
 */
export const channelJoinAction = <Data = undefined>(topic: string) => (
  data?: Data
): ChannelJoinAction<Data | undefined> =>
  createRedexAction(
    RedexActionType.ChannelJoin,
    RedexTypeKeys.REDEX_CHANNEL_JOIN,
    { topic },
    data
  );

/**
 * Returns an action that will cause Redex to join a socket.
 * @param data - The data to pass to the socket. Probably something like `{ token }`
 */
export const socketJoinAction = <Data = undefined>(
  data: Data
): SocketJoinAction<Data> =>
  createRedexAction(
    RedexActionType.SocketJoin,
    RedexTypeKeys.REDEX_SOCKET_JOIN,
    {},
    data
  );

const createRedexAction = <
  RedexType extends RedexActionType,
  Type extends string,
  RedexData,
  Data = undefined
>(
  redexType: RedexType,
  type: Type,
  redexData: RedexData,
  data: Data
): RedexAction<RedexType, Type, RedexData, Data> => ({
  data,
  redex: {
    data: redexData,
    type: redexType
  },
  type
});

export const withData = <T extends FSA<any>>(type: T["type"]) => (
  data: T["data"]
): T =>
  ({
    data,
    type
  } as T);

export const noData = <T extends FSA<undefined>>(type: T["type"]) => (): T =>
  ({
    type
  } as T);

export const isRedexAction = (
  action: FSA<any> | AnyRedexAction
): action is AnyRedexAction => Boolean((action as AnyRedexAction).redex);
