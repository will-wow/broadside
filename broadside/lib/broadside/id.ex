defmodule Broadside.Id do
  @type t :: String.t()

  def random(length \\ 32) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
