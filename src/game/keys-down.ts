import * as R from "ramda";

export interface t {
  [key: string]: boolean;
}

const filterKeysDown: (keysDown: t) => t = R.filter(R.identity);

export const recordKeyDown = (keysDown: t, { key }: KeyboardEvent): t =>
  R.assoc(key, true, keysDown);

export const recordKeyUp = (keysDown: t, { key }: KeyboardEvent): t =>
  R.assoc(key, false, keysDown);

export const pressedKeys: (keysDown: t) => string[] = R.pipe(
  filterKeysDown,
  R.keys
);

// const filterValidKeys = (validKeys: string[]) => (keys: string[]): string[] =>
//   R.filter<string>(isValidKey(validKeys), keys);

// const isValidKey = (validKeys: string[]) => (key: string): boolean =>
//   R.contains(key, validKeys);
