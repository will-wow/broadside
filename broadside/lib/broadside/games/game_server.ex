defmodule Broadside.Games.GameServer do
  use GenServer

  alias Broadside.Games.Game
  alias Broadside.Games.Action

  @type from :: tuple
  @type state :: Game.t()

  def start_link(args) do
    id = args[:id]
    name = args[:name]
    GenServer.start_link(__MODULE__, [id: id], name: name)
  end

  def get_state(pid) do
    GenServer.call(pid, :state)
  end

  @spec dispatch(pid, Action.t()) :: any
  def dispatch(pid, action) do
    GenServer.call(pid, {:dispatch, action})
  end

  @impl true
  @spec init(keyword) :: {:ok, state}
  def init(opts) do
    id = opts[:id]
    {:ok, %Game{id: id}}
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
    state = Game.update(state, action)

    {:reply, state, state}
  end
end
