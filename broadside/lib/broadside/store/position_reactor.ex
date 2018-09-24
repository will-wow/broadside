defmodule Broadside.Store.PositionReactor do
  alias Broadside.Store.Reactor
  alias Broadside.Store.Reducers
  alias Broadside.Store.KeysReducer
  alias Broadside.Store.Action

  @behaviour Reactor

  @spec react(Reducers.t(), Action.t()) :: none
  def react(
        store = %Reducers{keys: keys, game: game},
        %Action{type: :frame}
      ) do
    # TODO: Finish this
    # TODO: For each user, update the position, dispatch a bunch of boat moves (grouped in one action)
    position =
      keys_down
      |> KeysDown.pressed_keys()
      |> Enum.reduce(ship.position, fn key, position ->
        Position.change_from_key(position, key, @keys_to_changes)
      end)
      |> Position.frame()

    ship = ship |> struct!(position: position)

    state
    |> struct!(ships: [ship])
  end
end
