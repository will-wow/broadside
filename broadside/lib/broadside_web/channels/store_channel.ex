defmodule BroadsideWeb.StoreChannel do
  use BroadsideWeb, :channel

  alias Broadside.Store
  alias Broadside.Store.Action
  alias Broadside.Store.Transform

  @type socket :: Phoenix.Socket.t()

  @spec join(String.t(), map, socket) :: {:ok, socket} | {:error, map}
  def join("store:" <> user_id, _payload, socket) do
    case user_id == socket.assigns.user_id do
      true ->
        socket = assign(socket, :store, Store.reducer())
        {:ok, socket}

      false ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("dispatch", action = %Action{}, socket) do
    IO.inspect({"dispatch", action})
    store = socket.assigns.store

    store =
      Store.reducer(store, action)
      |> Store.reducer(%Action{type: :frame})

    socket = assign(socket, :store, store)

    push(socket, "store", Transform.to_json(store))

    {:noreply, socket}
  end

  def handle_in("dispatch", payload, socket) do
    action = Action.from_params(payload)
    handle_in("dispatch", action, socket)
  end

  def broadcast_frame() do
    :ok = BroadsideWeb.Endpoint.broadcast("store:*", "dispatch", %Action{type: :frame})
  end
end
