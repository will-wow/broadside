export interface t {
  x: number;
  y: number;
  velocity: number;
  heading: number;
  maxVelocity: number;
}

const postfix = (post: string) => (value: any): string => `${value}${post}`;

export const px = postfix("px");
export const percent = postfix("%");
export const vw = postfix("vw");
export const vh = postfix("vh");

export const translate = (maxX: number, maxY: number, { x, y }: t): string =>
  `translate(-50%, -50%) translate(${vw((x / maxX) * 90)}, ${vh(
    (y / maxY) * 90
  )})`;
export const rotate = ({ heading }: t): string => `rotate(${heading + 90}deg)`;
