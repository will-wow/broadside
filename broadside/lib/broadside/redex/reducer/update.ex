defmodule Redex.Reducer.Update do
  @type t(state) :: %__MODULE__{
          state: state
        }

  defstruct [:state]

  @spec new(state) :: t(state) when state: var
  def new(state) do
    %__MODULE__{state: state}
  end
end
