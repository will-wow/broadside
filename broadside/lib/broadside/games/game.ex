defmodule Broadside.Games.Game do
  alias __MODULE__
  alias Broadside.Games.Action
  alias Broadside.Games.Bullet
  alias Broadside.Games.Constants
  alias Broadside.Games.Position
  alias Broadside.Games.Ship
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

  @spec score(game :: t) :: [{String.t(), integer}]
  def score(%Game{users: users}) do
    users
    |> Enum.map(fn {user_id, user} ->
      {user_id, user.wins}
    end)
    |> Enum.sort_by(fn {_, wins} -> wins end)
  end

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
    ship = user.ship

    case Ship.reloading?(ship) do
      true ->
        game

      false ->
        ship_position = ship.position

        bullets =
          [
            Position.perpendicular(
              ship_position,
              :left,
              @bullet_speed,
              max_velocity: @bullet_speed
            ),
            Position.perpendicular(
              ship_position,
              :right,
              @bullet_speed,
              max_velocity: @bullet_speed
            )
          ]
          |> Enum.map(&Bullet.new(user_id, &1))
          |> Enum.concat(bullets)

        ship = Ship.shoot(ship)
        user = struct!(user, ship: ship)

        game
        |> update_user(user.id, user)
        |> struct!(bullets: bullets)
    end
  end

  @spec handle_hit(t, Bullet.t(), UserState.t()) :: t
  defp handle_hit(game, bullet, user) do
    game
    |> handle_hit_on_user(bullet, user)
    |> Map.update!(:bullets, fn bullets ->
      List.delete(bullets, bullet)
    end)
  end

  @spec handle_hit_on_user(t, Bullet.t(), UserState.t()) :: t
  defp handle_hit_on_user(game, bullet, hit_user) do
    case UserState.hit(hit_user) do
      {:dead, _user} ->
        game
        |> remove_user(hit_user.id)
        |> update_user(bullet.user_id, &UserState.win/1)

      {:alive, damaged_user} ->
        update_user(game, hit_user.id, damaged_user)
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

  @spec remove_user(t, String.t()) :: t
  defp remove_user(game, user_id) do
    game
    |> Map.update!(:users, fn users ->
      Map.delete(users, user_id)
    end)
  end

  @spec update_user(t, String.t(), UserState.t()) :: t
  defp update_user(game, user_id, user = %UserState{}) do
    game
    |> Map.update!(:users, fn users ->
      Map.put(users, user_id, user)
    end)
  end

  @spec update_user(t, String.t(), user_updater :: (UserState.t() -> UserState.t())) :: t
  defp update_user(game, user_id, user_updater) do
    game
    |> Map.update!(:users, fn users ->
      Map.update!(users, user_id, user_updater)
    end)
  end
end
