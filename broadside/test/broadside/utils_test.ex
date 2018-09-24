defmodule UtilsTest do
  use ExUnit.Case, async: true

  alias Utils

  test "add" do
    assert Utils.add(1).(2) == 3
  end

  test "subtract" do
    assert Utils.subtract(1).(2) == 1
  end

  test "mod" do
    assert Utils.mod(359, 360) == 359
    assert Utils.mod(360, 360) == 0
    assert Utils.mod(361, 360) == 1
  end

  test "clamp max" do
    assert Utils.clamp(10, 0, 9) == 9
  end

  test "clamp min" do
    assert Utils.clamp(10, 11, 12) == 11
  end

  test "clamp is fine" do
    assert Utils.clamp(10, 0, 12) == 10
  end
end
