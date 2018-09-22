import * as R from "ramda";
import * as Utils from "../utils";
import * as Radian from "./radian";

export interface t {
  x: number;
  y: number;
  velocity: number;
  heading: number;
}

export type ChangeType = "velocity" | "heading";

export interface Change {
  attribute: ChangeType;
  direction: -1 | 1;
}

export interface ChangeDictionary {
  [key: string]: Change;
}

const moveDeltas = {
  heading: 0.25,
  velocity: 3
};

const constrainPosition = R.evolve({
  heading: R.flip(R.modulo)(360),
  velocity: R.clamp(-9, 9),
  x: R.clamp(0, 1000),
  y: R.clamp(0, 1000)
});

export const change = ({ attribute, direction }: Change) => (
  position: t
): t => {
  const delta = moveDeltas[attribute] * direction;

  const newPosition = Utils.update<t>(attribute)(R.add(delta))(position);

  // tslint:disable:no-console
  console.log(newPosition);

  return constrainPosition(newPosition);
};

export const turn = (position: t): t => {
  let { x, y } = position;
  const { heading, velocity } = position;
  const radians = Radian.fromDegrees(heading);

  x = x + (velocity / 24) * Math.cos(radians);
  y = y + (velocity / 24) * Math.sin(radians);

  const newPosition = { ...position, x, y };
  return constrainPosition(newPosition);
};

// TODO: This should be heading & velocity
export const changeFromKey = (
  possibleChanges: ChangeDictionary,
  key: string,
  position: t
) => {
  const changeData = possibleChanges[key];

  if (!changeData) {
    return position;
  }

  return change(changeData)(position);
};
