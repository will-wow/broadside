defmodule BroadsideWeb.StoreChannel do
  use BroadsideWeb, :channel

  alias Broadside.Games.Action
  alias Broadside.Games.GameSupervisor
  alias Redex.Transform

  @type socket :: Phoenix.Socket.t()

  @spec join(String.t(), map, socket) :: {:ok, socket} | {:error, map}
  def join("store:" <> user_id, _payload, socket) do
    case user_id == socket.assigns.user_id do
      true ->
        {:ok, socket}

      false ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("new_game", _payload, socket) do
    case GameSupervisor.start_game() do
      {:ok, game_id} -> handle_in("join_game", %{"game_id" => game_id}, socket)
    end
  end

  def handle_in("join_game", %{"game_id" => game_id}, socket) do
    user_id = socket.assigns.user_id

    action = %Action.PlayerJoin{user_id: user_id}

    game = GameSupervisor.dispatch(game_id, action)

    socket = assign(socket, :game_id, game_id)

    broadcast(socket, "store", Transform.to_store("game", game))

    {:noreply, socket}
  end

  def handle_in("key_change", %{"event" => event, "key" => key}, socket) do
    user_id = socket.assigns.user_id
    game_id = socket.assigns.game_id

    action = %Action.KeyChange{user_id: user_id, event: String.to_existing_atom(event), key: key}

    game = GameSupervisor.dispatch(game_id, action)

    broadcast(socket, "store", Transform.to_store("game", game))

    {:noreply, socket}
  end

  @spec broadcast_store(user_id :: Id.t(), store_name :: String.t(), store :: any) :: :ok
  def broadcast_store(user_id, store_name, store) do
    BroadsideWeb.Endpoint.broadcast!(
      "store:#{user_id}",
      "store",
      Transform.to_store(store_name, store)
    )
  end
end
