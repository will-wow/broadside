import * as R from "ramda";
import * as Utils from "../utils";

export interface t {
  x: number;
  y: number;
  direction: number;
}

const attributeDeltas = {
  direction: 10,
  x: 10,
  y: 10
};

export const change = (attribute: keyof t) => (direction: 1 | -1) => (
  position: t
): t => {
  const delta = attributeDeltas[attribute] * direction;
  return Utils.update(attribute)(R.add(delta))(position);
};
