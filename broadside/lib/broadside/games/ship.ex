defmodule Broadside.Games.Ship do
  alias __MODULE__
  alias Broadside.Games.Position
  alias Broadside.Games.Constants

  @max_velocity Constants.get(:max_velocity)
  @max_health Constants.get(:max_health)

  @type t :: %Ship{
          id: String.t(),
          position: Position.t(),
          health: number
        }

  defstruct [:id, health: @max_health, position: %Position{}]

  @spec new(user_id :: String.t()) :: t
  def new(user_id) do
    %Ship{
      id: user_id,
      position:
        Position.random_start(
          radius: 10,
          max_velocity: @max_velocity
        )
    }
  end

  @spec hit(t) :: {:dead, t} | {:alive, t}
  def hit(ship = %Ship{health: health}) do
    damaged_ship = struct!(ship, health: health - 1)

    case dead?(damaged_ship) do
      true -> {:dead, ship}
      false -> {:alive, damaged_ship}
    end
  end

  @spec dead?(t) :: boolean
  defp dead?(%Ship{health: health}) do
    health <= 0
  end
end
