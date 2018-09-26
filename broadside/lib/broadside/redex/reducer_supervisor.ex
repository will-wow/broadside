defmodule Redex.ReducerSupervisor do
  @moduledoc """
  Handle supervising and communicating with reducers.
  """

  use DynamicSupervisor

  @type via :: {:via, Registry, tuple}
  @type state :: any

  alias Redex.ReducerRegistry

  def start_link(opts) do
    opts = Keyword.merge([name: __MODULE__], opts)

    DynamicSupervisor.start_link(__MODULE__, [], opts)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(room_id, reducer, user_id \\ nil) do
    spec = {
      reducer,
      name: child_via(room_id, reducer, user_id)
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @spec apply_action(any, any, atom, any | nil) :: state
  def apply_action(action, room_id, reducer, user_id \\ nil) do
    pid = get_child(room_id, reducer, user_id)
    reducer.apply_action(pid, action)
  end

  def get_child(room_id, reducer, user_id) do
    key = via_key(room_id, reducer, user_id)
    [{pid, _}] = Registry.lookup(ReducerRegistry, key)
    pid
  end

  @spec child_via(room_id :: any, reducer :: atom, user_id :: any | nil) :: via
  def child_via(room_id, reducer, user_id \\ nil) do
    key = via_key(room_id, reducer, user_id)

    {:via, Registry, {ReducerRegistry, key}}
  end

  @spec via_key(room_id :: any, reducer :: atom, user_id :: any | nil) :: tuple
  defp via_key(room_id, reducer, user_id) do
    case user_id do
      nil -> {room_id, reducer}
      user_id -> {room_id, reducer, user_id}
    end
  end
end
