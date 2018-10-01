import { Store } from "../reducers";
import { ShipData } from "./Ship";

export const getShips = (state: Store): ShipData[] => state.game.ships;
