defmodule Redex.Reducers do
  alias __MODULE__
  alias Broadside.Id
  alias Redex.CombinedReducer
  alias Broadside.Store.GameReducer
  alias Broadside.Store.KeysReducer
  alias Broadside.Store.PositionReactor
  alias Redex.ReducerSupervisor

  alias Redex.Action

  defstruct game: GameReducer.reduce(), keys: %{}

  @type t :: %Reducers{
          game: GameReducer.t(),
          keys: %{optional(Id.t()) => KeysReducer.t()}
        }

  @reducers %CombinedReducer{
    reducers: [
      game: GameReducer
    ],
    user_reducers: [
      keys: KeysReducer
    ],
    reactors: [PositionReactor]
  }

  @spec reduce(any, [any], Action.t()) :: t
  def reduce(room_id, user_ids, action = %Action{}) do
    reducer_stream =
      @reducers.reducers
      |> Task.async_stream(fn {name, reducer} ->
        {
          name,
          ReducerSupervisor.apply_action(action, room_id, reducer)
        }
      end)

    user_reducer_stream =
      @reducers.user_reducers
      |> Task.async_stream(fn {name, reducer} ->
        {
          name,
          apply_action_to_user_reducers(action, room_id, user_ids, reducer)
        }
      end)

    reducer_keyword_list =
      reducer_stream
      |> Stream.concat(user_reducer_stream)
      |> Result.collect_oks!()

    store = struct(Reducers, reducer_keyword_list)

    _ =
      @reducers.reactors
      |> Enum.each(fn reactor ->
        Task.start(fn ->
          reactor.react(store)
        end)
      end)

    store
  end

  defp apply_action_to_user_reducers(action, room_id, user_ids, reducer) do
    user_ids
    |> Task.async_stream(fn user_id ->
      {
        user_id,
        ReducerSupervisor.apply_action(action, room_id, reducer, user_id)
      }
    end)
    |> Result.collect_oks!()
    |> Enum.into(%{})
  end
end
