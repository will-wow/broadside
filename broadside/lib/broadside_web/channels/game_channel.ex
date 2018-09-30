defmodule BroadsideWeb.GameChannel do
  use BroadsideWeb, :channel

  alias Broadside.Games.Action
  alias Broadside.Games.Game
  alias Broadside.Games.GameSupervisor
  alias BroadsideWeb.GameView

  @type socket :: Phoenix.Socket.t()

  def join("game:" <> game_id, _payload, socket) do
    case socket.assigns.user_id do
      nil ->
        {:error, %{reason: :not_logged_in}}

      user_id ->
        socket = assign(socket, :game_id, game_id)

        action = %Action.PlayerJoin{user_id: user_id}

        case GameSupervisor.dispatch(game_id, action) do
          {:ok, game} ->
            broadcast_game_state(socket, game)

            {:ok, game, socket}

          {:error, msg} ->
            {:error, %{reason: msg}}
        end
    end
  end

  def handle_in("key_change", %{"event" => event, "key" => key}, socket) do
    user_id = socket.assigns.user_id
    game_id = socket.assigns.game_id

    action = %Action.KeyChange{user_id: user_id, event: String.to_existing_atom(event), key: key}

    game_id
    |> GameSupervisor.dispatch(action)
    |> Result.map_ok(&broadcast_game_state(socket, &1))

    {:noreply, socket}
  end

  @spec broadcast_game_state(socket, Game.t()) :: :ok
  def broadcast_game_state(socket, game = %Game{}) do
    data = GameView.render(game)

    broadcast(socket, "game_state", data)
  end
end
