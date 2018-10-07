defmodule Broadside.Accounts do
  alias Broadside.Id

  @one_day 1000 * 60 * 60 * 24

  def new_user() do
    Id.random()
  end

  @spec new_token(map, String.t()) :: String.t()
  def new_token(context, user_id) do
    Phoenix.Token.sign(context, "user", user_id)
  end

  @spec verify_token(map, String.t()) :: {:ok, Id.t()} | {:error, any}
  def verify_token(context, token) do
    Phoenix.Token.verify(context, "user", token, max_age: @one_day)
  end
end
