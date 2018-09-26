defmodule BroadsideWeb.StoreChannel do
  use BroadsideWeb, :channel

  alias Broadside.Games.Constants
  alias Broadside.Games.FrameInterval
  alias Broadside.Id
  alias Broadside.Store.GameReducer
  alias Redex.Action
  alias Redex.Transform
  # alias Broadside.Games.CombineReducer

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

        socket = assign(socket, :store, GameReducer.reduce())
        {:ok, socket}

      false ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("dispatch", payload, socket) do
    action = Action.from_params(payload)
    store = socket.assigns.store
    store = GameReducer.reduce(store, action)
    socket = assign(socket, :store, store)

    push(socket, "store", Transform.to_json(store))

    {:noreply, socket}
  end

  def handle_out("dispatch", action = %Action{}, socket) do
    store = socket.assigns.store
    store = GameReducer.reduce(store, action)
    socket = assign(socket, :store, store)

    push(socket, "store", Transform.to_json(store))

    {:noreply, socket}
  end

  @spec dispatch(room_id :: Id.t(), action :: Action.t()) :: :ok
  def dispatch(room_id, action) do
    BroadsideWeb.Endpoint.broadcast!("store:#{room_id}", "dispatch", action)
  end

  @spec broadcast_frame(any()) :: :ok
  def broadcast_frame(user_id) do
    dispatch(user_id, %Action{type: :frame})
  end
end
