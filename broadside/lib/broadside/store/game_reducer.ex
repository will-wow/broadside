defmodule Broadside.Store.GameReducer do
  alias __MODULE__
  alias Broadside.Game.Position
  alias Broadside.Game.Position.Change
  alias Broadside.Game.Ship
  alias Broadside.Games.Constants
  alias Broadside.KeysDown
  alias Broadside.Store.Action
  alias Broadside.Store.Reducer

  @behaviour Reducer

  @fps Constants.get(:fps)
  @max_speed Constants.get(:max_speed)

  @type t :: %GameReducer{
          max_speed: number,
          fps: number,
          keys_down: KeysDown.t(),
          ships: [Ship.t()],
          bullets: []
        }

  defstruct [:fps, :max_speed, :keys_down, :ships, :bullets]

  @keys_to_changes %{
    "a" => %Change{attribute: :heading, direction: -1},
    "d" => %Change{attribute: :heading, direction: 1},
    "s" => %Change{attribute: :velocity, direction: -1},
    "w" => %Change{attribute: :velocity, direction: 1}
  }

  @spec reduce() :: t()
  def reduce() do
    %GameReducer{
      fps: @fps,
      max_speed: @max_speed,
      keys_down: %KeysDown{},
      ships: [
        Ship.new()
      ],
      bullets: []
    }
  end

  def reduce(state = %GameReducer{}, _) do
    state
  end
end
