// tslint:disable:no-console

import * as R from "ramda";

type Updater<T> = (x: T) => T;

const updatePath = <T, U>(path: Array<string | number>) => (
  f: Updater<any>
) => (object: T) => {
  const value: any = R.path(path, object);
  const updatedValue = f(value);
  return R.assocPath(path, updatedValue, object);
};

export const update: <T>(
  key: keyof T
) => (f: Updater<T[keyof T]>) => (object: T) => T = key =>
  updatePath([key as string]);

export const log = (...args: any[]) => <T>(data: T): T => {
  console.log.apply(null, args.concat([data]));
  return data;
};
