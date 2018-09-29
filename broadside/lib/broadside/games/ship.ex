defmodule Broadside.Games.Ship do
  alias __MODULE__
  alias Broadside.Games.Position
  alias Broadside.Games.Constants

  @max_speed Constants.get(:max_speed)

  @type t :: %Ship{
          id: String.t(),
          max_speed: number,
          position: Position.t()
        }

  defstruct [:id, position: %Position{}, max_speed: @max_speed]

  @spec new(user_id :: String.t()) :: t
  def new(user_id) do
    %Ship{
      id: user_id
    }
  end
end
