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
  @bullet_speed Constants.get(:bullet_speed)
  @bullet_range @bullet_speed / 2

  @type t :: %Game{
          id: Id.t(),
          fps: number,
          bullets: [],
          users: %{
            optional(Id.t()) => UserState.t()
          }
        }

  defstruct [:id, fps: @fps, users: %{}, bullets: []]

  @spec ships(game :: t) :: [Ship.t()]
  def ships(%Game{users: users}) do
    users
    |> Enum.map(fn {_user_id, user} ->
      user.ship
    end)
  end

  @spec player?(t, Id.t()) :: boolean
  def player?(game, user_id) do
    Map.has_key?(game.users, user_id)
  end

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
        action = %Action.KeyChange{user_id: user_id}
      ) do
    case player?(game, user_id) do
      true ->
        game
        |> update_shot(action)
        |> update_keys_down(action)

      false ->
        game
    end
  end

  def update(
        game = %Game{},
        %Action.Frame{}
      ) do
    game
    |> frame_users()
    |> frame_bullets()
    |> frame_collisions()
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

  defp frame_users(game = %Game{users: users}) do
    users =
      users
      |> Enum.map(fn {user_id, user} ->
        {user_id, UserState.frame(user)}
      end)
      |> Enum.into(%{})

    struct!(game, users: users)
  end

  @spec frame_bullets(t) :: t
  defp frame_bullets(game = %Game{bullets: bullets}) do
    bullets =
      bullets
      |> Enum.map(fn bullet ->
        Map.update!(bullet, :position, &Position.frame/1)
      end)

    struct!(game, bullets: bullets)
  end

  @spec frame_collisions(t) :: t
  defp frame_collisions(game = %Game{bullets: bullets, users: users}) do
    bullets
    |> Enum.reduce(game, fn bullet, game ->
      bullet_user_id = bullet.user_id

      hit_user =
        Enum.find(users, fn
          {^bullet_user_id, _} ->
            false

          {_user_id, user} ->
            Position.collision?(bullet.position, user.ship.position)
        end)

      case hit_user do
        nil ->
          check_bullet_distance(game, bullet)

        {_, hit_user} ->
          handle_hit(game, bullet, hit_user)
      end
    end)
  end

  @spec add_bullet(Game.t(), Id.t()) :: Game.t()
  defp add_bullet(game = %Game{users: users, bullets: bullets}, user_id) do
    user = users[user_id]

    ship_position = user.ship.position

    bullets =
      [
        Position.perpendicular(
          ship_position,
          :left,
          velocity: @bullet_speed,
          max_velocity: @bullet_speed
        ),
        Position.perpendicular(
          ship_position,
          :right,
          velocity: @bullet_speed,
          max_velocity: @bullet_speed
        )
      ]
      |> Enum.map(&Bullet.new(user_id, &1))
      |> Enum.concat(bullets)

    struct!(game, bullets: bullets)
  end

  @spec handle_hit(t, Bullet.t(), UserState.t()) :: t
  defp handle_hit(game, bullet, user) do
    game
    |> handle_hit_on_user(user)
    |> Map.update!(:bullets, fn bullets ->
      List.delete(bullets, bullet)
    end)
  end

  @spec handle_hit_on_user(t, UserState.t()) :: t
  defp handle_hit_on_user(game, user) do
    case UserState.hit(user) do
      {:dead, _user} ->
        game
        |> Map.update!(:users, fn users ->
          Map.delete(users, user.id)
        end)

      {:alive, damaged_user} ->
        game
        |> Map.update!(:users, fn users ->
          Map.put(users, user.id, damaged_user)
        end)
    end
  end

  @spec check_bullet_distance(t, Bullet.t()) :: t
  defp check_bullet_distance(game, bullet) do
    case Position.distance(bullet.position, bullet.starting_position) > @bullet_range do
      true ->
        Map.update!(game, :bullets, fn bullets ->
          List.delete(bullets, bullet)
        end)

      false ->
        game
    end
  end
end
