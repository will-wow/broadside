import * as R from "ramda";
import { Action as ReduxAction } from "redux";
import * as Channels from "./channels-service";

export interface FSA<Data = any, Type = string> extends ReduxAction {
  type: Type;
  data: Data;
}

export interface RedexAction<
  Action extends FSA,
  Redex extends RedexMetadata<any, RedexActionType>
> {
  data: Action["data"];
  redex: Redex;
  type: Action["type"];
}

export type AnyRedexAction =
  | SocketJoinAction<FSA>
  | ChannelJoinAction<FSA>
  | ChannelPushAction<FSA>;

export type SocketJoinAction<Action extends FSA> = RedexAction<
  Action,
  RedexMetadata<{}, RedexActionType.SocketJoin>
>;

export type ChannelJoinAction<Action extends FSA> = RedexAction<
  Action,
  RedexMetadata<ChannelJoinActionData, RedexActionType.ChannelJoin>
>;

export type ChannelPushAction<Action extends FSA> = RedexAction<
  Action,
  RedexMetadata<ChannelPushActionData, RedexActionType.ChannelPush>
>;

interface RedexMetadata<RedexData, RedexType extends RedexActionType> {
  data: RedexData;
  type: RedexType;
}

interface ChannelJoinActionData {
  topic: string;
  // TODO
  eventsToActions: Channels.EventsToActions;
}

interface ChannelPushActionData {
  topic: string;
  // TODO
  channelEvent?: string;
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

// export const channelAction = <Action extends FSA>(
//   channelInfo: ChannelPushActionData,
//   action: Action
// ): ChannelPushAction<Action> =>
//   R.merge(action, {
//     redex: {
//       data: channelInfo,
//       type: RedexActionType.ChannelPush as RedexActionType.ChannelPush
//     }
//   });

export function channelAction<Action extends FSA>(
  channelInfo: ChannelPushActionData
): (action: Action) => ChannelPushAction<FSA<Action["data"], Action["type"]>>;
export function channelAction<Action extends FSA>(
  channelInfo: ChannelPushActionData,
  action: Action
): ChannelPushAction<Action>;
export function channelAction<Action extends FSA>(
  channelInfo: ChannelPushActionData,
  action?: Action
) {
  if (action) {
    return R.merge(action, {
      redex: {
        data: channelInfo,
        type: RedexActionType.ChannelPush as RedexActionType.ChannelPush
      }
    });
  } else {
    return (action: Action) => channelAction(channelInfo, action);
  }
}

/**
 * Wrap an action so that it will also cause Redex to join a channel.
 * Requires an open socket first.
 * @param topic - The name of the socket to join.
 * @param data - The data to pass to the channel.
 */
export const channelJoinAction = <Action extends FSA>(
  channelInfo: ChannelJoinActionData
) => (action: Action): ChannelJoinAction<Action> =>
  createRedexAction(action, {
    data: channelInfo,
    type: RedexActionType.ChannelJoin
  });

/**
 * Returns an action that will cause Redex to join a socket.
 * @param data - The data to pass to the socket. Probably something like `{ token }`
 */
export const socketJoinAction = <Action extends FSA>(socketInfo: any) => (
  action: Action
): SocketJoinAction<Action> =>
  createRedexAction(action, {
    data: socketInfo,
    type: RedexActionType.SocketJoin
  });

/**
 * True if the action is decorated with data to be sent to redex.
 * @param action Tr
 */
export const isRedexAction = (
  action: FSA | AnyRedexAction
): action is AnyRedexAction => Boolean((action as AnyRedexAction).redex);

/**
 * Creates an action that redex will also consume.
 * @param action The FSA
 * @param redex The redex metadata
 */
const createRedexAction = <
  Action extends FSA,
  RedexData extends RedexMetadata<any, RedexActionType>
>(
  action: Action,
  redex: RedexData
): RedexAction<Action, RedexData> => ({
  data: action.data,
  redex,
  type: action.type
});
