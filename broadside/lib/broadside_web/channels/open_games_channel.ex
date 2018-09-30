defmodule BroadsideWeb.OpenGamesChannel do
  use BroadsideWeb, :channel

  alias Broadside.Games.Action
  alias Broadside.Games.Game
  alias Broadside.Games.GameSupervisor
  alias Redex.Transform

  @type socket :: Phoenix.Socket.t()

  @spec join(String.t(), map, socket) :: {:ok, socket} | {:error, map}
  def join("open_games:lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("new_game", _payload, socket) do
    case GameSupervisor.start_game() do
      {:ok, game_id} ->
        push(socket, "game_created", %{game_id: game_id})

        broadcast(socket, "new_game", %{game_id: game_id})

        {:noreply, socket}
    end
  end
end
