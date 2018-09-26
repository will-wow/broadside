defmodule Redex.Reducer.SideEffects do
  @type t :: %__MODULE__{
          f: f
        }

  @type f :: (() -> none)

  defstruct [:f]

  @spec new(f :: f) :: t
  def new(f) do
    %__MODULE__{f: f}
  end
end
