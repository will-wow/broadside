defmodule Broadside.Games.PositionTest do
  use ExUnit.Case, async: true

  alias Broadside.Games.Constants
  alias Broadside.Games.Position
  alias Broadside.Games.Position.Change

  @max_velocity Constants.get(:max_velocity)

  test "constrain position" do
    position = %Position{
      heading: 370,
      velocity: 100,
      x: -10,
      y: 2000
    }

    assert Position.constrain_position(position) == %Position{
             position
             | velocity: @max_velocity,
               max_velocity: @max_velocity,
               x: 0,
               y: 1000
           }
  end

  test "change_from_key" do
    position = %Position{velocity: 2}
    key = "w"

    possible_changes = %{
      "w" => %Change{attribute: :velocity, direction: 1}
    }

    assert Position.change_from_key(position, key, possible_changes) == %Position{
             position
             | velocity: 3
           }
  end

  test "collision? detects an exact collision" do
    position1 = %Position{x: 1, y: 1, radius: 1}

    assert Position.collision?(position1, position1) == true
  end

  test "collision? detects a near collision" do
    position1 = %Position{x: 1, y: 1, radius: 2}
    position2 = %Position{x: 4, y: 1, radius: 2}

    assert Position.collision?(position1, position1) == true
  end

  test "collision? detects a miss" do
    position1 = %Position{x: 1, y: 1, radius: 1}
    position2 = %Position{x: 4, y: 1, radius: 1}

    assert Position.collision?(position1, position1) == true
  end
end
