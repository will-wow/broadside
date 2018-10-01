import * as R from "ramda";
import { Dispatch } from "redux";
import { Channel, Socket } from "phoenix";
import * as Utils from "../utils";

import * as RedexActions from "./actions";
import * as Action from "./action";

export interface EventsToActions {
  [topic: string]: string;
}

export interface EventAndAction {
  event: string;
  action: string;
}

interface ChannelData {
  channel: Channel;
  eventAndActions: EventAndAction[];
}

interface ChannelMap {
  [topic: string]: ChannelData;
}

export default class Channels {
  private socket: Socket;
  private channels: ChannelMap = {};

  constructor(private endpoint: string, private dispatch: Dispatch) {}

  openSocket = (token: string) => {
    const socket = new Socket(this.endpoint, {
      params: { token }
    });
    socket.connect();
    this.socket = socket;
  };

  connectToChannel = (
    topic: string,
    eventsToActions: EventsToActions,
    opts: any = {}
  ) => {
    const channel = this.socket.channel(topic, opts);

    channel.join().receive("ok", (_: any) => {
      const channelData: ChannelData = {
        channel,
        eventAndActions: parseEventsToActions(eventsToActions)
      };

      this.listen(channelData);

      this.channels[topic] = channelData;

      this.dispatch(RedexActions.onChannelConnectSuccess({ topic }));
    });
  };

  sendMessage = ({ topic, type, data }: Action.ChannelAction) => {
    const { channel, eventAndActions } = this.channels[topic];

    const event = actionToEvent(eventAndActions)(type);

    channel.push(event, data);
  };

  isChannelReady = ({ topic }: Action.ChannelAction): boolean =>
    Boolean(this.channels[topic]);

  private listen = (channelData: ChannelData) => {
    R.map(({ event, action }) => {
      channelData.channel.on(event, (response: any) =>
        this.dispatch({
          data: response,
          type: action
        })
      );

      return [event, action];
    }, channelData.eventAndActions);
  };
}

const actionToEvent = (eventAndActions: EventAndAction[]) => (
  action: string
): string =>
  R.pipe(
    R.find(isAction(action)),
    getEvent(action)
  )(eventAndActions);

const parseEventsToActions = (
  eventAndActions: EventsToActions
): EventAndAction[] =>
  Utils.mapPairs<EventsToActions>(([event, action]) => ({ event, action }))(
    eventAndActions
  );

const isAction: (
  event: string
) => (eventAndAction: EventAndAction) => boolean = R.propEq("action");

const getEvent = (defaultName: string) => (
  eventAndAction: EventAndAction
): string => R.propOr(defaultName, "event", eventAndAction);

// const eventToAction = (eventAndActions: EventAndAction[]) => (
//   event: string
// ): string =>
//   R.pipe(
//     R.find(isEvent(event)),
//     getAction
//   )(eventAndActions);

// const isEvent: (
//   event: string
// ) => (EventAndAction: EventAndAction) => boolean = R.propEq("event");

// const getAction: (EventAndAction: EventAndAction) => string = R.prop("action");
