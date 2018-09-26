defmodule Broadside.Game.Ship do
  alias __MODULE__
  alias Broadside.Game.Position
  alias Broadside.Games.Constants

  @type t :: %Ship{
          id: String.t(),
          position: Position.t()
        }

  defstruct [:id, :position, :max_speed]

  @max_speed Constants.get(:max_speed)

  @spec new(user_id :: String.t()) :: t
  def new(user_id) do
    %Ship{
      id: user_id,
      position: %Position{},
      max_speed: @max_speed
    }
  end
end
