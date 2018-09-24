defmodule BroadsideWeb.UserSocket do
  use Phoenix.Socket

  @type socket :: Phoenix.Socket.t()

  @one_day 1000 * 60 * 60 * 24

  ## Channels
  channel "store:*", BroadsideWeb.StoreChannel

  ## Transports
  transport(:websocket, Phoenix.Transports.WebSocket)
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user", token, max_age: @one_day) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}

      {:error, msg} ->
        {:error, msg}
    end
  end

  @doc """
  Socket id's are topics that allow you to identify all sockets for a given user:
  """
  @spec id(socket) :: String.t()
  def id(socket), do: "user_socket:#{socket.assigns.user_id}"
end
