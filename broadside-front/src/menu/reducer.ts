import { RedexReducerConfig } from "../redex/reducers";

export interface t {
  games: string[];
}

export const reducer: RedexReducerConfig<t> = {
  initialState: {
    games: []
  },
  name: "menu"
};
