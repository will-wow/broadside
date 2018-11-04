import * as RedexAction from "../redex/action";

export enum TypeKeys {
  GAME_ENDED = "menu:game_ended",
  GAME_LIST = "menu:game_list",
  GAME_STARTED = "menu:game_started",
  JOIN_GAME = "menu:join_game",
  LOGIN = "menu:login",
  NEW_GAME = "menu:new_game",
  NEW_GAME_SUCCESS = "menu:new_game:success"
}

export type Action =
  | GameEndedAction
  | GameListAction
  | GameStartedAction
  | JoinGameAction
  | LoginAction
  | NewGameAction
  | NewGameActionSuccess;

interface GameEndedAction {
  type: TypeKeys.GAME_ENDED;
  data: {
    gameId: string;
  };
}

interface GameListAction {
  type: TypeKeys.GAME_LIST;
  data: {
    games: string[];
  };
}

interface LoginAction {
  type: TypeKeys.LOGIN;
  data: {
    userId: string;
  };
}

interface GameStartedAction {
  type: TypeKeys.GAME_STARTED;
  data: {
    gameId: string;
  };
}

interface JoinGameAction {
  type: TypeKeys.JOIN_GAME;
  data: {
    gameId: string;
  };
}

type NewGameAction = RedexAction.ChannelPushAction<
  undefined,
  TypeKeys.NEW_GAME
>;

interface NewGameActionSuccess {
  type: TypeKeys.NEW_GAME_SUCCESS;
  data: {
    gameId: string;
  };
}

export const eventsToActions = {
  game_ended: TypeKeys.GAME_ENDED,
  game_list: TypeKeys.GAME_LIST,
  game_started: TypeKeys.GAME_STARTED,
  join_game: TypeKeys.JOIN_GAME,
  login: TypeKeys.LOGIN,
  new_game: TypeKeys.NEW_GAME,
  new_game_created: TypeKeys.NEW_GAME_SUCCESS
};

export const onJoinGame = (data: { gameId: string }): JoinGameAction => ({
  data,
  type: TypeKeys.JOIN_GAME
});

export const onNewGame = RedexAction.channelAction(
  {
    topic: "open_games:lobby"
  },
  { type: TypeKeys.NEW_GAME, data: undefined }
);

/**
 * Pass a token to the socket to connect to it. Create a function for this to declare the type of data the socket needs, and so components don't need to know about redex.
 */
export const onSocketConnect = (token: string) =>
  RedexAction.socketJoinAction({ token });

export const onChannelConnect = () =>
  RedexAction.channelJoinAction("open_games:lobby")();
