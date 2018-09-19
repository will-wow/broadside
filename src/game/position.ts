import * as R from "ramda";
import * as Utils from "../utils";

export interface t {
  x: number;
  y: number;
  direction: number;
}
export interface Change {
  attribute: keyof t;
  direction: -1 | 1;
}

export interface ChangeDictionary {
  [key: string]: Change;
}

const attributeDeltas = {
  direction: 0.25,
  x: 0.25,
  y: 0.25
};

export const change = ({ attribute, direction }: Change) => (
  position: t
): t => {
  const delta = attributeDeltas[attribute] * direction;
  return Utils.update(attribute)(R.add(delta))(position);
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
