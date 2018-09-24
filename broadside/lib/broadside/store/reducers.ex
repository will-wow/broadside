defmodule Broadside.Store.Reducers do
  alias __MODULE__
  alias Broadside.Store.CombinedReducer
  alias Broadside.Store.GameReducer
  alias Broadside.Store.KeysReducer
  alias Broadside.Store.PositionReactor

  alias Broadside.Store.Action

  defstruct game: GameReducer.reduce(), keys: %{}

  @type t :: %Reducers{
          game: GameReducer.t(),
          keys: %{optional(String.t()) => KeysReducer.t()}
        }

  @reducers CombinedReducer.new(
              reducers: [
                game: GameReducer
              ],
              user_reducers: [
                keys: KeysReducer
              ],
              reactors: [PositionReactor]
            )

  @spec reduce() :: t
  def reduce() do
    %Reducers{}
  end

  @spec reduce(t, Action.t()) :: t
  def reduce(store, action = %Action{}) do
    # TODO: Put each reducer in a agent. Task.async for each reducer call.
    store =
      @reducers.reducers
      |> Enum.reduce(store, fn {name, module}, store ->
        store
        |> Map.update!(name, &module.reduce.(&1, action))
      end)

    store =
      @reducers.user_reducers
      |> Enum.reduce(store, fn {name, module}, store ->
        store
        |> Map.update!(name, &update_user_reducer(&1, module, action))
      end)

    @reducers.reactors
    |> Enum.each(fn reactor ->
      Task.start(fn -> reactor.react(store, action) end)
    end)

    store
  end

  defp update_user_reducer(state, module, action) do
    state
    |> Enum.map(fn {user_id, state} ->
      state = module.reduce.(state, action)
      {user_id, state}
    end)
  end
end
