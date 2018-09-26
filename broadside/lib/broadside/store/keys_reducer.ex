defmodule Broadside.Store.KeysReducer do
  alias __MODULE__
  alias Redex.Action
  alias Broadside.KeysDown

  @type t :: %KeysReducer{
          keys_down: KeysDown.t()
        }

  defstruct keys_down: %KeysDown{}

  use Redex.Reducer

  @impl true
  @spec reduce(state :: t, Action.t()) :: Reducer.return_value(t)
  def reduce(state, %Action{type: :key_down, data: key}) do
    keys_down = KeysDown.record_key_down(state.keys_down, key)

    state
    |> struct!(keys_down: keys_down)
    |> Update.new()
  end

  def reduce(state, %Action{type: :key_up, data: key}) do
    keys_down = KeysDown.record_key_up(state.keys_down, key)

    state
    |> struct!(keys_down: keys_down)
    |> Update.new()
  end

  def reduce(%KeysReducer{}, _) do
    NoUpdate.new()
  end
end
