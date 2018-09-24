defmodule Broadside.Store.Action do
  alias __MODULE__

  @type t :: %Action{
          type: atom | nil,
          data: any | nil
        }

  defstruct [:type, :data]

  @spec from_params(map) :: t
  def from_params(params) do
    type = params["type"]
    data = params["data"]

    type = String.to_existing_atom(type)

    %Action{type: type, data: data}
  end
end
