defmodule Broadside.Games.GameSupervisor do
  @moduledoc """
  Handle starting and communicating with games.
  """

  use DynamicSupervisor

  alias Broadside.Games.Constants
  alias Broadside.Games.Game
  alias Broadside.Games.Action
  alias Broadside.Id
  alias Broadside.Games.FrameInterval
  alias BroadsideWeb.StoreChannel

  @type via :: {:via, Registry, any}
  @type state :: any

  @frame_length Constants.get(:ms_per_frame)

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
      Game,
      name: child_via(game_id)
    }

    __MODULE__
    |> DynamicSupervisor.start_child(spec)
    |> Result.map_ok(fn _ -> game_id end)
  end

  @spec dispatch(Id.t(), Action.t()) :: Game.t()
  def dispatch(game_id, action) do
    pid = get_child(game_id)
    Game.dispatch(pid, action)
  end

  def get_child(game_id) do
    key = via_key(game_id)
    [{pid, _}] = Registry.lookup(Broadside.Registry, key)
    pid
  end

  def frame() do
    all_games()
    |> Enum.map(fn game_pid ->
      Game.dispatch(game_pid, %Action.Frame{})
    end)
    |> Enum.each(fn game_state ->
      game_state.users
      |> Map.keys()
      |> Enum.map(fn user_id ->
        StoreChannel.broadcast_store(user_id, "game", game_state)
      end)

      # TODO: Report back to channel
      nil
    end)
  end

  @spec all_games() :: [pid]
  defp all_games() do
    DynamicSupervisor.which_children(__MODULE__)
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
