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

interface NewGameAction extends RedexAction.ChannelAction {
  type: TypeKeys.NEW_GAME;
}

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

export const onJoinGame = RedexAction.withData<JoinGameAction>(
  TypeKeys.JOIN_GAME
);

export const onNewGame = RedexAction.channelAction<NewGameAction>(
  TypeKeys.NEW_GAME,
  "open_games:lobby"
);
