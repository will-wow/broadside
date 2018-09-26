defmodule Broadside.Store.GameReducer do
  @moduledoc """
  Hold shared game state.
  """

  alias __MODULE__
  alias Broadside.Id
  alias Broadside.Game.Ship
  alias Broadside.Games.Constants
  alias Redex.Action

  @fps Constants.get(:fps)
  @max_speed Constants.get(:max_speed)

  @type t :: %GameReducer{
          max_speed: number,
          fps: number,
          ships: %{optional(Id.t()) => Ship.t()},
          bullets: []
        }

  defstruct fps: @fps, max_speed: @max_speed, ships: %{}, bullets: []

  use Redex.Reducer

  @impl true
  @spec reduce(state :: t, action :: Action.t()) :: Reducer.return_value(t)
  def reduce(
        state = %GameReducer{ships: ships},
        %Action{type: :add_player, user_id: user_id}
      ) do
    ships = [Ship.new(user_id) | ships]

    state
    |> struct(ships: ships)
    |> Update.new()
  end

  def reduce(
        state = %GameReducer{},
        %Action{type: :change_position, data: ships}
      ) do
    state
    |> struct(ships: ships)
    |> Update.new()
  end

  def reduce(_state, _action) do
    NoUpdate.new()
  end
end
