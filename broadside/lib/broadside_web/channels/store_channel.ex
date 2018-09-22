defmodule BroadsideWeb.StoreChannel do
  use BroadsideWeb, :channel

  @type socket :: Phoenix.Socket.t()

  @spec join(String.t(), map, socket) :: {:ok, socket} | {:error, map}
  def join("store:" <> user_id, _payload, socket) do
    case user_id == socket.assigns.user_id do
      true -> {:ok, socket}
      false -> {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (store:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end
end
