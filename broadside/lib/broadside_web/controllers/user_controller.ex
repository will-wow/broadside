defmodule BroadsideWeb.UserController do
  use BroadsideWeb, :controller

  def create(conn, _) do
    id = random_user_id()
    token = sign_token(conn, id)

    json(conn, %{id: id, token: token})
  end

  defp random_user_id() do
    length = 32

    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  @spec sign_token(Plug.Conn.t(), String.t()) :: String.t()
  defp sign_token(conn, user_id) do
    Phoenix.Token.sign(conn, "user", user_id)
  end
end
