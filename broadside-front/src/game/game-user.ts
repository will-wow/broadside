import { ShipData } from "./Ship";

export interface t {
  ship: ShipData;
}

export const getShip = (user: t): ShipData => user.ship;
