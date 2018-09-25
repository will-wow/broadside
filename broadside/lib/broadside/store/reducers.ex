defmodule Broadside.Store.Reducers do
  alias __MODULE__
  alias Broadside.Store.CombinedReducer
  alias Broadside.Store.GameReducer
  alias Broadside.Store.KeysReducer
  alias Broadside.Store.PositionReactor
  alias Broadside.Store.Reducer.NoUpdate
  alias Broadside.Store.Reducer.Update
  alias Broadside.Store.Reducer.SideEffects
  alias Broadside.Store.Reducer.UpdateWithSideEffects

  alias Broadside.Store.Action

  defstruct game: GameReducer.reduce(), keys: %{}

  @type t :: %Reducers{
          game: GameReducer.t(),
          keys: %{optional(String.t()) => KeysReducer.t()}
        }

  @type store_and_side_effects :: {store, keyword}

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
    {store, side_effects} =
      @reducers.reducers
      |> Enum.reduce({store, []}, &reduce_reducers/2)

    {store, side_effects} =
      @reducers.user_reducers
      |> Enum.reduce({store, side_effects}, &reduce_user_reducers/2)

    @reducers.reactors
    |> Enum.each(fn reactor ->
      Task.start(fn -> reactor.react(store, action) end)
    end)

    store
  end

  @spec reduce_reducers({atom, atom}, store_and_side_effects) :: store_and_side_effects
  defp reduce_reducers({name, module}, {store, side_effects}) do
    old_state = Map.fetch!(store, name)

    {state, side_effects} = update_state(module, old_state, side_effects)

    store = Map.put(store, name, state)

    {store, side_effects}
  end

  @spec reduce_user_reducers({atom, atom}, store_and_side_effects) :: store_and_side_effects
  defp reduce_user_reducers({name, module}, {store, side_effects}) do
    store
    |> Map.fetch!(name)
    |> Enum.reduce({store, side_effects})

    store
    |> Map.update!(name, &update_user_reducer(&1, module, action))
  end

  defp reduce_user_reducer(module) do
    fn {user_id, state}, {users_state, side_effects}) ->
      users_state
    |> Enum.reduce({store, side_effects})

    store
    |> Map.update!(name, &update_user_reducer(&1, module, action))
  end

  defp update_user_reducer(state, module, action) do
    state
    |> Enum.map(fn {user_id, state} ->
      state = module.reduce.(state, action)
      {user_id, state}
    end)
  end

  defp update_state(module, old_state, side_effects) do
    output = module.reduce(old_state, action)

    state = new_state(output, old_state)
    side_effects = enqueue_side_effect(output, state, side_effects)

    {state, side_effects}
  end

  defp new_state(output, old_state) do
    case output do
      %Update{state: state} -> state
      %UpdateWithSideEffects{state: state} -> state
      _ -> old_state
    end
  end

  defp enqueue_side_effect(output, state, side_effects) do
    case output do
      %SideEffects{f: f} -> f
      %UpdateWithSideEffects{f: f} -> f
      _ -> nil
    end
    |> case do
      nil -> side_effects
      f -> [{f, state} | side_effects]
    end
  end

  defp handle_reducer_output(output, name, store, side_effects) do
    case output do
      %NoUpdate{} ->
        {store, side_effects}

      %Update{state: state} ->
        {Map.put(store, name, state), side_effects}

      %SideEffects{f: f} ->
        {store, [{name, f} | side_effects]}

      %UpdateWithSideEffects{state: state, f: f} ->
        {Map.put(store, name, state), [{name, f} | side_effects]}
    end
  end
end
