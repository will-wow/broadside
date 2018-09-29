defmodule Redex.Reducer.SideEffects do
  @type t(state) :: %__MODULE__{
          f: f(state)
        }

  @type f(state) :: (user_id :: any, state :: state -> none)

  defstruct [:f]

  @spec new(f(state)) :: t(state) when state: var
  def new(f) do
    %__MODULE__{f: f}
  end
end
