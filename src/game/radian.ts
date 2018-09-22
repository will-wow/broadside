export type t = number;

export const toDegrees = (radians: t): number => radians * (180 / Math.PI);

export const fromDegrees = (degrees: number): t => degrees * (Math.PI / 180);
