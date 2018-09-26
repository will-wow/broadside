defmodule Broadside.Store.PositionReactor do
  @moduledoc """
  Handle updating the position every frame.
  """

  alias Broadside.Id
  alias Broadside.Game.Position
  alias Broadside.Game.Position.Change
  alias Broadside.Game.Ship
  alias Broadside.KeysDown
  alias Redex.Reactor
  alias Redex.Action
  alias Redex.Reducers
  alias BroadsideWeb.StoreChannel

  @behaviour Reactor

  @keys_to_changes %{
    "a" => %Change{attribute: :heading, direction: -1},
    "d" => %Change{attribute: :heading, direction: 1},
    "s" => %Change{attribute: :velocity, direction: -1},
    "w" => %Change{attribute: :velocity, direction: 1}
  }

  @spec react(store :: Reducers.t(), action :: Action.t(), room_id :: Id.t()) :: any
  def react(
        %Reducers{keys: keys, game: game},
        %Action{type: :frame},
        room_id
      ) do
    ships =
      game.ships
      |> Enum.map(fn ship = %Ship{id: user_id} ->
        update_ship_from_keys(
          ship,
          keys[user_id].keys_down
        )
      end)

    StoreChannel.dispatch(room_id, %Action{
      type: :change_position,
      data: ships
    })
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
