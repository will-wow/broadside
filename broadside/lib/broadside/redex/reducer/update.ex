defmodule Redex.Reducer.Update do
  @type t :: %__MODULE__{
          state: state
        }

  @type state :: any

  defstruct [:state]

  @spec new(state :: state) :: t
  def new(state) do
    %__MODULE__{state: state}
  end
end
