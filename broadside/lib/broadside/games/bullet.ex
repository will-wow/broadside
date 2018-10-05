defmodule Broadside.Games.Bullet do
  alias __MODULE__
  alias Broadside.Games.Position
  alias Broadside.Id

  @type t :: %Bullet{
          id: Id.t(),
          user_id: Id.t(),
          position: Position.t(),
          starting_position: Position.t()
        }

  defstruct [:id, :user_id, :position, :starting_position]

  @spec new(Id.t(), Position.t()) :: t
  def new(user_id, starting_position) do
    starting_position =
      starting_position
      |> struct!(radius: 5)

    %Bullet{
      id: Id.random(8),
      user_id: user_id,
      position: starting_position,
      starting_position: starting_position
    }
  end
end
