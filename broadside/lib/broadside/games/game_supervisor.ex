defmodule Broadside.Games.GameSupervisor do
  @moduledoc """
  Handle starting and communicating with games.
  """

  use DynamicSupervisor

  alias Broadside.Games.Constants
  alias Broadside.Games.Game
  alias Broadside.Games.GameServer
  alias Broadside.Games.Action
  alias Broadside.Id
  alias Broadside.Games.FrameInterval
  alias BroadsideWeb.GameChannel

  @type via :: {:via, Registry, any}
  @type state :: any

  @frame_length Constants.get(:ms_per_frame)

  @spec start_link(keyword) :: {:ok, pid}
  def start_link(opts) do
    opts = Keyword.merge([name: __MODULE__], opts)

    {:ok, pid} = DynamicSupervisor.start_link(__MODULE__, [], opts)

    {:ok, _pid} = start_frames()

    {:ok, pid}
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp start_frames() do
    spec = {
      FrameInterval,
      interval: @frame_length, on_tick: &frame/0
    }

    __MODULE__
    |> DynamicSupervisor.start_child(spec)
  end

  def start_game() do
    game_id = Id.random()

    spec = {
      GameServer,
      id: game_id, name: child_via(game_id)
    }

    __MODULE__
    |> DynamicSupervisor.start_child(spec)
    |> Result.map_ok(fn _ -> game_id end)
  end

  @spec dispatch(Id.t(), Action.t()) :: Result.t(Game.t(), atom)
  def dispatch(game_id, action) do
    game_id
    |> get_child()
    |> Result.map_ok(&GameServer.dispatch(&1, action))
  end

  @spec get_child(Id.t()) :: Result.t(pid, :not_found)
  def get_child(game_id) do
    key = via_key(game_id)

    case Registry.lookup(Broadside.Registry, key) do
      [{pid, _}] -> {:ok, pid}
      _ -> {:error, :not_found}
    end
  end

  @spec all_game_ids() :: [Id.t()]
  def all_game_ids() do
    all_games()
    |> Enum.map(fn game_pid ->
      Broadside.Registry
      |> Registry.keys(game_pid)
      |> List.first()
    end)
  end

  @spec frame() :: :ok
  def frame() do
    all_games()
    |> Enum.map(fn game_pid ->
      GameServer.dispatch(game_pid, %Action.Frame{})
    end)
    |> Enum.each(&GameChannel.broadcast_game_state/1)
  end

  @spec broadcast_state_to_game(Id.t()) :: Result.t(:ok, atom)
  def broadcast_state_to_game(game_id) do
    game_id
    |> get_game_state()
    |> Result.map_ok(&GameChannel.broadcast_game_state/1)
  end

  @spec get_game_state(Id.t()) :: Result.t(Game.t(), atom)
  def get_game_state(game_id) do
    game_id
    |> get_child()
    |> Result.map_ok(&GameServer.get_state/1)
  end

  @spec all_games() :: [pid]
  defp all_games() do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Enum.filter(fn {_, pid, _type, modules} ->
      case {pid, modules} do
        {:restarting, _} -> false
        {_, [FrameInterval]} -> false
        {_pid, _} -> true
      end
    end)
    |> Enum.map(fn {_, pid, _, _} ->
      pid
    end)
  end

  @spec child_via(Id.t()) :: via
  def child_via(game_id) do
    key = via_key(game_id)

    {:via, Registry, {Broadside.Registry, key}}
  end

  @spec via_key(Id.t()) :: Id.t()
  defp via_key(game_id), do: game_id
end
