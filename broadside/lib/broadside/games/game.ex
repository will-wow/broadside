defmodule Broadside.Games.Game do
  alias __MODULE__
  alias Broadside.Games.Action
  alias Broadside.Games.Bullet
  alias Broadside.Games.Constants
  alias Broadside.Games.Ship
  alias Broadside.Games.Position
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
        game = %Game{},
        action = %Action.KeyChange{}
      ) do
    game
    |> update_shot(action)
    |> update_keys_down(action)
  end

  def update(
        game = %Game{},
        %Action.Frame{}
      ) do
    game
    |> users_frame()
    |> bullets_frame()
  end

  @spec ships(game :: t) :: [Ship.t()]
  def ships(%Game{users: users}) do
    users
    |> Enum.map(fn {_user_id, user} ->
      user.ship
    end)
  end

  defp update_keys_down(
         game = %Game{users: users},
         %Action.KeyChange{event: event, key: key, user_id: user_id}
       ) do
    users =
      Map.update!(users, user_id, fn user ->
        UserState.update_keys_down(user, key, event)
      end)

    struct!(game, users: users)
  end

  @spec update_shot(t, Action.KeyChange.t()) :: t
  defp update_shot(
         game = %Game{users: users},
         %Action.KeyChange{event: :down, key: " ", user_id: user_id}
       ) do
    case users[user_id].keys_down.keys[" "] do
      true -> game
      _ -> add_bullet(game, user_id)
    end
  end

  defp update_shot(game = %Game{}, _) do
    game
  end

  defp users_frame(game = %Game{users: users}) do
    users =
      users
      |> Enum.map(fn {user_id, user} ->
        {user_id, UserState.frame(user)}
      end)
      |> Enum.into(%{})

    struct!(game, users: users)
  end

  defp bullets_frame(game = %Game{bullets: bullets}) do
    bullets =
      bullets
      |> Enum.map(fn bullet ->
        Map.update!(bullet, :position, &Position.frame/1)
      end)

    struct!(game, bullets: bullets)
  end

  @spec add_bullet(Game.t(), Id.t()) :: Game.t()
  defp add_bullet(game = %Game{users: users, bullets: bullets}, user_id) do
    user = users[user_id]

    ship_position = user.ship.position

    bullets =
      [
        Position.perpendicular(ship_position, :left, 100),
        Position.perpendicular(ship_position, :right, 100)
      ]
      |> Enum.map(&Bullet.new(user_id, &1))
      |> Enum.concat(bullets)

    struct!(game, bullets: bullets)
  end
end
