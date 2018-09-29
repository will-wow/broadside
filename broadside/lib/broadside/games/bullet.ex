defmodule Broadside.Games.Bullet do
  alias __MODULE__
  alias Broadside.Games.Position
  alias Broadside.Id

  @type t :: %Bullet{
          id: String.t(),
          position: Position.t()
        }

  defstruct [:id, :position]

  @spec new() :: t
  def new() do
    %Bullet{
      id: Id.random(8),
      position: %Position{}
    }
  end
end
