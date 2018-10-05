defmodule Broadside.Games.GameTest do
  use ExUnit.Case, async: true

  alias Broadside.Games.Action
  alias Broadside.Games.Bullet
  alias Broadside.Games.Game
  alias Broadside.Games.Position
  alias Broadside.Games.Ship
  alias Broadside.Games.UserState

  test "constrain position" do
    game = %Game{
      bullets: [
        %Bullet{
          position: %Position{
            x: 0,
            y: 0,
            heading: 90,
            velocity: 1
          },
          starting_position: %Position{
            x: 0,
            y: 0,
            heading: 90,
            velocity: 1
          }
        }
      ],
      users: %{
        "alice" => %UserState{
          id: "alice",
          ship: %Ship{
            id: "alice",
            health: 1,
            position: %Position{
              x: 1,
              y: 1
            }
          }
        }
      }
    }

    assert %Game{
             users: %{}
           } = Game.update(game, %Action.Frame{})
  end
end
