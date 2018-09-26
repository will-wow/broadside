defmodule Redex.Action do
  alias __MODULE__

  @type t :: %Action{
          type: atom | nil,
          data: any | nil,
          user_id: any | nil
        }

  defstruct [:type, :data, :user_id]

  @spec from_params(map) :: t
  def from_params(params) do
    type = params["type"]
    data = params["data"]
    user_id = params["user_id"]

    type = String.to_existing_atom(type)

    %Action{type: type, data: data, user_id: user_id}
  end
end
