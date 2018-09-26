defmodule Redex.Reducer.NoUpdate do
  @type t :: %__MODULE__{}

  defstruct []

  @spec new() :: t
  def new() do
    %__MODULE__{}
  end
end
