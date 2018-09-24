defmodule Broadside.Store do
  alias __MODULE__
  alias Broadside.Store.Action
  alias Broadside.Position
  alias Broadside.Position.Change
  alias Broadside.KeysDown
  alias Broadside.Games.Constants

  @fps Constants.get(:fps)
  @max_speed Constants.get(:max_speed)

  @type t :: %Store{
          max_speed: number,
          fps: number,
          keys_down: KeysDown.t(),
          ship_position: Position.t()
        }

  defstruct [:fps, :max_speed, :keys_down, :ship_position]

  @keys_to_changes %{
    "a" => %Change{attribute: :heading, direction: -1},
    "d" => %Change{attribute: :heading, direction: 1},
    "s" => %Change{attribute: :velocity, direction: -1},
    "w" => %Change{attribute: :velocity, direction: 1}
  }

  @spec reducer() :: t()
  def reducer() do
    %Store{
      fps: @fps,
      max_speed: @max_speed,
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
      |> Position.frame()

    state
    |> struct!(ship_position: position)
  end

  def reducer(state = %Store{}, _) do
    state
  end
end
