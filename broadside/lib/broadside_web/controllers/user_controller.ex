defmodule BroadsideWeb.UserController do
  use BroadsideWeb, :controller

  alias Plug.Conn
  alias Broadside.Accounts

  @spec create(Conn.t(), any) :: Conn.t()
  def create(conn, _) do
    id = Accounts.new_user()
    token = Accounts.new_token(conn, id)

    json(conn, %{id: id, token: token})
  end
end
