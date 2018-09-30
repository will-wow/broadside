import { RedexReducerConfig } from "../redex/reducers";

import * as UserState from "./game-user";
import { BulletData } from "./Bullet";

export interface t {
  fps?: number;
  users: { [userId: string]: UserState.t };
  bullets: BulletData[];
}

export const reducer: RedexReducerConfig<t> = {
  initialState: {
    bullets: [],
    users: {}
  },
  name: "game"
};
