defmodule BroadsideWeb.UserController do
  use BroadsideWeb, :controller
  alias Broadside.Id

  def create(conn, _) do
    id = Id.random()
    token = sign_token(conn, id)

    json(conn, %{id: id, token: token})
  end

  @spec sign_token(Plug.Conn.t(), String.t()) :: String.t()
  defp sign_token(conn, user_id) do
    Phoenix.Token.sign(conn, "user", user_id)
  end
end
