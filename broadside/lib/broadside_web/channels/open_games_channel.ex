defmodule BroadsideWeb.OpenGamesChannel do
  use BroadsideWeb, :channel

  alias Broadside.Games.GameSupervisor
  alias Redex.Transform

  @type socket :: Phoenix.Socket.t()

  @spec join(String.t(), map, socket) :: {:ok, socket} | {:error, map}
  def join("open_games:lobby", _payload, socket) do
    send(self(), :after_join)

    {:ok, socket}
  end

  def handle_in("new_game", _payload, socket) do
    case GameSupervisor.start_game() do
      {:ok, game_id} ->
        data = %{game_id: game_id} |> Transform.to_json()

        push(socket, "new_game_created", data)

        broadcast(socket, "game_started", data)

        {:noreply, socket}
    end
  end

  def handle_info(:after_join, socket) do
    game_ids = GameSupervisor.all_game_ids()
    data = Transform.to_json(%{games: game_ids})

    push(socket, "game_list", data)
    {:noreply, socket}
  end
end
