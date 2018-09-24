defmodule Broadside.Store.KeysReducer do
  alias __MODULE__
  alias Broadside.Store.Action
  alias Broadside.KeysDown
  alias Broadside.Store.Reducer

  @behaviour Reducer

  @type t :: %KeysReducer{
          keys_down: KeysDown.t()
        }

  defstruct [:keys_down]

  @spec reduce() :: t()
  def reduce() do
    %KeysReducer{
      keys_down: %KeysDown{}
    }
  end

  def reduce(state, %Action{type: :key_down, data: key}) do
    keys_down = KeysDown.record_key_down(state.keys_down, key)

    state
    |> struct!(keys_down: keys_down)
  end

  def reduce(state, %Action{type: :key_up, data: key}) do
    keys_down = KeysDown.record_key_up(state.keys_down, key)

    state
    |> struct!(keys_down: keys_down)
  end

  def reduce(state = %KeysReducer{}, _) do
    state
  end
end
