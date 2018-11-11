// tslint:disable:no-console

import * as R from "ramda";

type Updater<T> = (x: T) => T;

export type StringOf<T> = Extract<keyof T, string>;
export type ValueOf<T> = T[keyof T];

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

export const mapValues = <T extends object>(f: ((value: any) => any), obj: T) =>
  R.pipe(
    R.values,
    R.map(f)
  )(obj);

export const mapPairs = <T extends object>(
  f: (<K extends StringOf<T>>(pair: [K, T[K]]) => any)
) => (obj: T): any[] =>
  R.pipe(
    R.toPairs,
    R.map(f)
  )(obj);

export const sample = <T>(xs: T[]): T => {
  const i = Math.floor(Math.random() * xs.length);

  return xs[i];
};
