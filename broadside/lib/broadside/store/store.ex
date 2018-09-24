defmodule Broadside.Store do
  alias __MODULE__
  alias Broadside.Store.Action
  alias Broadside.Position
  alias Broadside.Position.Change
  alias Broadside.KeysDown

  @type t :: %Store{
          keys_down: KeysDown.t(),
          ship_position: Position.t()
        }

  defstruct [:keys_down, :ship_position]

  @keys_to_changes %{
    "a" => %Change{attribute: :heading, direction: -1},
    "d" => %Change{attribute: :heading, direction: 1},
    "s" => %Change{attribute: :velocity, direction: -1},
    "w" => %Change{attribute: :velocity, direction: 1}
  }

  @spec reducer() :: t()
  def reducer() do
    %Store{
      keys_down: %KeysDown{},
      ship_position: %Position{}
    }
  end

  @spec reducer(t, Action.t()) :: t()
  def reducer(_state, %Action{type: :start_game}) do
    %Store{
      keys_down: %KeysDown{},
      ship_position: %Position{}
    }
  end

  def reducer(state, %Action{type: :key_down, data: key}) do
    keys_down = KeysDown.record_key_down(state.keys_down, key)

    state
    |> struct!(keys_down: keys_down)
  end

  def reducer(state, %Action{type: :key_up, data: key}) do
    keys_down = KeysDown.record_key_up(state.keys_down, key)

    state
    |> struct!(keys_down: keys_down)
  end

  def reducer(state = %Store{keys_down: keys_down, ship_position: position}, %Action{type: :frame}) do
    position =
      keys_down
      |> KeysDown.pressed_keys()
      |> Enum.reduce(position, fn key, position ->
        Position.change_from_key(position, key, @keys_to_changes)
      end)
      |> Position.turn()

    state
    |> struct!(ship_position: position)
  end

  def reducer(state = %Store{}, _) do
    state
  end
end
