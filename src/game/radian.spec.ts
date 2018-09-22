import * as Radian from "./radian";

describe("radian", () => {
  it("converts from degrees", () => {
    expect(Radian.fromDegrees(15)).toEqual(Math.PI / 12);
  });

  it("converts to degrees", () => {
    expect(Radian.toDegrees(Math.PI / 12)).toBeCloseTo(15);
  });
});
