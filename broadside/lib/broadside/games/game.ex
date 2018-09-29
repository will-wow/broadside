defmodule Broadside.Games.Game do
  use GenServer

  alias __MODULE__
  alias Broadside.Id
  alias Broadside.Games.Constants
  alias Broadside.Games.Action
  alias Broadside.Games.UserState

  @fps Constants.get(:fps)

  @type t :: %Game{
          fps: number,
          bullets: [],
          users: %{
            optional(Id.t()) => UserState.t()
          }
        }

  @type from :: tuple

  defstruct fps: @fps, users: %{}, bullets: []

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  @spec dispatch(pid, Action.t()) :: any
  def dispatch(pid, action) do
    GenServer.call(pid, action)
  end

  @impl true
  def init(_) do
    {:ok, %__MODULE__{}}
  end

  @impl true
  @spec handle_call(Action.t(), from, t) :: {:reply, t, t}
  def handle_call(
        %Action.PlayerJoin{user_id: user_id},
        _from,
        state = %Game{users: users}
      ) do
    users = Map.put(users, user_id, UserState.new(user_id))
    state = struct!(state, users: users)

    {:reply, state, state}
  end

  @impl true
  def handle_call(
        %Action.KeyChange{event: event, key: key, user_id: user_id},
        _from,
        state = %Game{users: users}
      ) do
    users =
      Map.update!(users, user_id, fn user ->
        UserState.update_keys_down(user, key, event)
      end)

    state = struct(state, users: users)

    {:reply, state, state}
  end

  @impl true
  def handle_call(
        %Action.Frame{},
        _from,
        state = %Game{users: users}
      ) do
    users =
      users
      |> Enum.map(fn {user_id, user} ->
        {user_id, UserState.frame(user)}
      end)
      |> Enum.into(%{})

    state = struct(state, users: users)

    {:reply, state, state}
  end
end
