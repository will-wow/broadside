export interface t {
  x: number;
  y: number;
  velocity: number;
  heading: number;
}

const postfix = (post: string) => (value: any): string => `${value}${post}`;

export const px = postfix("px");

export const translate = ({ x, y }: t): string =>
  `translate(${px(x)}, ${px(y)})`;
export const rotate = ({ heading }: t): string => `rotate(${heading + 90}deg)`;
