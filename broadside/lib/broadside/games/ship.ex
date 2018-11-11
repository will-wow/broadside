defmodule Broadside.Games.Ship do
  alias __MODULE__
  alias Broadside.Games.Position
  alias Broadside.Games.Constants

  @max_velocity Constants.get(:max_velocity)
  @max_health Constants.get(:max_health)

  @type t :: %Ship{
          id: String.t(),
          position: Position.t(),
          health: number,
          reloading: float
        }

  @fps Constants.get(:fps)
  @reload_seconds Constants.get(:reload_speed)
  @reload_per_frame 1 / (@reload_seconds * @fps)

  defstruct [:id, health: @max_health, position: %Position{}, reloading: 0.0]

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

  @spec shoot(t) :: t
  def shoot(ship = %Ship{}) do
    %Ship{ship | reloading: 1.0}
  end

  @spec frame_reload(t) :: t
  def frame_reload(ship = %Ship{reloading: reloading}) do
    cond do
      reloading == 0.0 ->
        ship

      reloading < 0.0 ->
        %Ship{ship | reloading: 0.0}

      reloading > 0.0 ->
        reloading = reloading - @reload_per_frame

        %Ship{ship | reloading: reloading}
    end
  end

  @spec reloading?(t) :: boolean()
  def reloading?(%Ship{reloading: 0.0}), do: false
  def reloading?(_), do: true

  @spec dead?(t) :: boolean
  defp dead?(%Ship{health: health}) do
    health <= 0
  end
end
