defmodule BroadsideWeb.StoreChannel do
  use BroadsideWeb, :channel

  alias Broadside.Store
  alias Broadside.Store.Action
  alias Broadside.Store.Transform
  alias Broadside.Games.FrameInterval
  alias Broadside.Games.Constants

  @type socket :: Phoenix.Socket.t()

  @frame_length Constants.get(:ms_per_frame)

  intercept ["dispatch"]

  @spec join(String.t(), map, socket) :: {:ok, socket} | {:error, map}
  def join("store:" <> user_id, _payload, socket) do
    case user_id == socket.assigns.user_id do
      true ->
        _ =
          FrameInterval.start_link(
            interval: @frame_length,
            on_tick: fn ->
              broadcast_frame(user_id)
            end
          )

        socket = assign(socket, :store, Store.reducer())
        {:ok, socket}

      false ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("dispatch", payload, socket) do
    action = Action.from_params(payload)
    store = socket.assigns.store
    store = Store.reducer(store, action)
    socket = assign(socket, :store, store)

    push(socket, "store", Transform.to_json(store))

    {:noreply, socket}
  end

  def handle_out("dispatch", action = %Action{}, socket) do
    store = socket.assigns.store
    store = Store.reducer(store, action)
    socket = assign(socket, :store, store)

    push(socket, "store", Transform.to_json(store))

    {:noreply, socket}
  end

  def broadcast_frame(user_id) do
    BroadsideWeb.Endpoint.broadcast!("store:#{user_id}", "dispatch", %Action{type: :frame})
  end
end
