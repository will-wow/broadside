defmodule Broadside.PositionTest do
  use ExUnit.Case, async: true

  alias Broadside.Position
  alias Broadside.Position.Change

  test "constrain position" do
    position = %Position{
      heading: 370,
      velocity: 100,
      x: -10,
      y: 2000
    }

    assert Position.constrain_position(position) == %Position{
             heading: 10,
             velocity: 9,
             x: 0,
             y: 1000
           }
  end

  test "change_from_key" do
    position = %Position{}
    key = "w"

    possible_changes = %{
      "w" => %Change{attribute: :velocity, direction: 1}
    }

    assert Position.change_from_key(position, key, possible_changes) == %Position{
             velocity: 3
           }
  end
end
