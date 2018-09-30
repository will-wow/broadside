defmodule Broadside.Games.GameServer do
  use GenServer

  alias Broadside.Games.Game
  alias Broadside.Games.Action

  @type from :: tuple
  @type state :: Game.t()

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def get_state(pid) do
    GenServer.call(pid, :state)
  end

  @spec dispatch(pid, Action.t()) :: any
  def dispatch(pid, action) do
    GenServer.call(pid, {:dispatch, action})
  end

  @impl true
  @spec init(any) :: {:ok, state}
  def init(_) do
    {:ok, %Game{}}
  end

  @impl true
  @spec handle_call(:state, from, state) :: {:reply, Game.t(), state}
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  @spec handle_call({:dispatch, Action.t()}, from, state) :: {:reply, Game.t(), state}
  def handle_call(
        {:dispatch, action},
        _from,
        state = %Game{}
      ) do
    Game.update(state, action)

    {:reply, state, state}
  end
end
