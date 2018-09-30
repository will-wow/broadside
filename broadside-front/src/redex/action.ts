import { Action } from "redux";

export interface t<T = any> extends Action {
  type: string;
  data: T;
}

export const simple = (type: string) => (data?: any): t => ({ data, type });
