defmodule Redex.Reducer.UpdateWithSideEffects do
  @type t(state) :: %__MODULE__{
          state: state,
          f: f(state)
        }

  @type f(state) :: (state -> none)

  defstruct [:state, :f]

  @spec new(state, f(state)) :: t(state) when state: var
  def new(state, f) do
    %__MODULE__{state: state, f: f}
  end
end
