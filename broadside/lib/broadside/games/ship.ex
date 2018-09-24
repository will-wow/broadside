defmodule Broadside.Game.Ship do
  alias __MODULE__
  alias Broadside.Game.Position
  alias Broadside.Id
  alias Broadside.Games.Constants

  @type t :: %Ship{
          id: String.t(),
          position: Position.t()
        }

  defstruct [:id, :position, :max_speed]

  @max_speed Constants.get(:max_speed)

  @spec new() :: t
  def new() do
    %Ship{
      id: Id.random(8),
      position: %Position{},
      max_speed: @max_speed
    }
  end
end
