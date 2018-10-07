defmodule Broadside.Games.Score do
  alias __MODULE__
  alias Broadside.Id
  alias Broadside.Games.UserState

  @type t :: %Score{
          score: integer,
          user_id: Id.t()
        }

  defstruct [:user_id, score: 0]

  @spec from_user(UserState.t()) :: t
  def from_user(%UserState{wins: wins, id: id}) do
    %Score{
      score: wins,
      user_id: id
    }
  end
end
