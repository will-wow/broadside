defmodule Broadside.Games.UserState do
  alias __MODULE__
  alias Broadside.Games.Ship
  alias Broadside.Games.KeysDown
  alias Broadside.Games.Position
  alias Broadside.Games.Position.Change

  @type t :: %__MODULE__{
          id: Id.t(),
          ship: Ship.t(),
          keys_down: KeysDown.t(),
          wins: integer
        }
  @type event :: :up | :down

  @keys_to_changes %{
    "a" => %Change{attribute: :heading, direction: -1},
    "d" => %Change{attribute: :heading, direction: 1},
    "s" => %Change{attribute: :velocity, direction: -1},
    "w" => %Change{attribute: :velocity, direction: 1}
  }

  defstruct [:id, ship: %Ship{}, keys_down: %KeysDown{}, wins: 0]

  def new(user_id) do
    %UserState{
      id: user_id,
      ship: Ship.new(user_id)
    }
  end

  @spec update_keys_down(t, String.t(), event) :: t
  def update_keys_down(user, key, event) do
    keys_down =
      user.keys_down
      |> KeysDown.record_key_change(event, key)

    struct!(user, keys_down: keys_down)
  end

  @spec frame(t) :: t
  def frame(
        user = %UserState{
          keys_down: keys_down,
          ship: ship
        }
      ) do
    ship =
      ship
      |> update_ship_from_keys(keys_down)
      |> Ship.frame_reload()

    struct!(user, ship: ship)
  end

  @spec hit(t) :: {:dead, t} | {:alive, t}
  def hit(user = %UserState{ship: ship}) do
    case Ship.hit(ship) do
      {:dead, _ship} ->
        {:dead, user}

      {:alive, damaged_ship} ->
        {:alive, struct!(user, ship: damaged_ship)}
    end
  end

  @doc """
  Record a win
  """
  @spec win(t) :: t
  def win(user = %UserState{}) do
    Map.update!(user, :wins, &(&1 + 1))
  end

  defp update_ship_from_keys(ship, keys_down) do
    position =
      keys_down
      |> KeysDown.pressed_keys()
      |> Enum.reduce(ship.position, fn key, position ->
        Position.change_from_key(position, key, @keys_to_changes)
      end)
      |> Position.frame()

    ship
    |> struct!(position: position)
  end
end
