defmodule Broadside.Game.RadianTest do
  use ExUnit.Case, async: true

  alias Broadside.Game.Radian

  test "converts from degrees" do
    assert Radian.from_degrees(15) == Radian.new(:math.pi() / 12)
  end

  test "converts to degrees" do
    assert_in_delta(
      Radian.to_degrees(Radian.new(:math.pi() / 12)),
      15.0,
      0.01
    )
  end
end
