defmodule Broadside.Games.UserState do
  alias __MODULE__
  alias Broadside.Games.Ship
  alias Broadside.Games.KeysDown
  alias Broadside.Games.Position
  alias Broadside.Games.Position.Change

  @type t :: %__MODULE__{
          ship: Ship.t(),
          keys_down: KeysDown.t()
        }

  @keys_to_changes %{
    "a" => %Change{attribute: :heading, direction: -1},
    "d" => %Change{attribute: :heading, direction: 1},
    "s" => %Change{attribute: :velocity, direction: -1},
    "w" => %Change{attribute: :velocity, direction: 1}
  }

  defstruct ship: %Ship{}, keys_down: %KeysDown{}

  def new(user_id) do
    %UserState{
      ship: Ship.new(user_id)
    }
  end

  def update_keys_down(user, key, event) do
    keys_down =
      user.keys_down
      |> KeysDown.record_key_change(event, key)

    struct!(user, keys_down: keys_down)
  end

  @spec frame(t) :: t
  def frame(
        user = %UserState{
          keys_down: keys_down,
          ship: ship
        }
      ) do
    ship = update_ship_from_keys(ship, keys_down)

    struct!(user, ship: ship)
  end

  defp update_ship_from_keys(ship, keys_down) do
    position =
      keys_down
      |> KeysDown.pressed_keys()
      |> Enum.reduce(ship.position, fn key, position ->
        Position.change_from_key(position, key, @keys_to_changes)
      end)
      |> Position.frame()

    ship
    |> struct!(position: position)
  end
end
