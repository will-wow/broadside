defmodule Redex.Reducer.UpdateWithSideEffects do
  @type t :: %__MODULE__{
          state: state,
          f: f
        }

  @type state :: any
  @type f :: (() -> none)

  defstruct [:state, :f]

  @spec new(state :: state, f :: f) :: t
  def new(state, f) do
    %__MODULE__{state: state, f: f}
  end
end
