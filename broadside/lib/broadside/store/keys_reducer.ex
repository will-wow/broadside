defmodule Broadside.Store.KeysReducer do
  use Redex.Reducer

  alias __MODULE__
  alias Redex.Action
  alias Broadside.KeysDown
  alias Redex.Reducer

  @type t :: %KeysReducer{
          keys_down: KeysDown.t()
        }

  defstruct [:keys_down]

  @impl true
  @spec reduce() :: t()
  def reduce() do
    %KeysReducer{
      keys_down: %KeysDown{}
    }
  end

  @impl true
  @spec reduce(state :: t, Action.t()) :: t()
  def reduce(state, %Action{type: :key_down, data: key}) do
    keys_down = KeysDown.record_key_down(state.keys_down, key)

    state
    |> struct!(keys_down: keys_down)
    |> Reducer.Update.new()
  end

  def reduce(state, %Action{type: :key_up, data: key}) do
    keys_down = KeysDown.record_key_up(state.keys_down, key)

    state
    |> struct!(keys_down: keys_down)
    |> Reducer.Update.new()
  end

  def reduce(state = %KeysReducer{}, _) do
    Reducer.NoUpdate.new()
  end
end
