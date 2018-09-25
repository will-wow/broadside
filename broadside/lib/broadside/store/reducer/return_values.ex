defmodule Broadside.Store.Reducer.NoUpdate do
  @type t :: %__MODULE__{}

  defstruct []

  @spec new() :: t
  def new() do
    %__MODULE__{}
  end
end

defmodule Broadside.Store.Reducer.Update do
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

defmodule Broadside.Store.Reducer.SideEffects do
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

defmodule Broadside.Store.Reducer.UpdateWithSideEffects do
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
