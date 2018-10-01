defmodule Broadside.Games.Game do
  alias __MODULE__
  alias Broadside.Games.Action
  alias Broadside.Games.Constants
  alias Broadside.Games.Ship
  alias Broadside.Games.UserState
  alias Broadside.Id

  @fps Constants.get(:fps)

  @type t :: %Game{
          id: Id.t(),
          fps: number,
          bullets: [],
          users: %{
            optional(Id.t()) => UserState.t()
          }
        }

  defstruct [:id, fps: @fps, users: %{}, bullets: []]

  @spec update(t, Action.t()) :: t
  def update(
        game = %Game{users: users},
        %Action.PlayerJoin{user_id: user_id}
      ) do
    users = Map.put(users, user_id, UserState.new(user_id))
    struct!(game, users: users)
  end

  def update(
        game = %Game{users: users},
        %Action.KeyChange{event: event, key: key, user_id: user_id}
      ) do
    users =
      Map.update!(users, user_id, fn user ->
        UserState.update_keys_down(user, key, event)
      end)

    struct!(game, users: users)
  end

  def update(
        game = %Game{users: users},
        %Action.Frame{}
      ) do
    users =
      users
      |> Enum.map(fn {user_id, user} ->
        {user_id, UserState.frame(user)}
      end)
      |> Enum.into(%{})

    struct!(game, users: users)
  end

  @spec ships(game :: t) :: [Ship.t()]
  def ships(%Game{users: users}) do
    users
    |> Enum.map(fn {_user_id, user} ->
      user.ship
    end)
  end
end
