defmodule Broadside.Games.Position do
  alias __MODULE__
  alias __MODULE__.Change
  alias Broadside.Games.Radian
  alias Broadside.Games.Constants

  @type t :: %Position{
          x: number,
          y: number,
          velocity: number,
          heading: number
        }

  @type possible_changes :: %{optional(String.t()) => Change.t()}

  defstruct x: 0.0, y: 0.0, velocity: 0.0, heading: 0.0

  @fps Constants.get(:fps)
  @max_speed Constants.get(:max_speed)

  @move_deltas %{
    heading: 45,
    velocity: 10
  }

  def constrain_position(%Position{heading: heading, velocity: velocity, x: x, y: y}) do
    %Position{
      heading: heading,
      velocity: Utils.clamp(velocity, -@max_speed, @max_speed),
      x: Utils.clamp(x, 0, 1000),
      y: Utils.clamp(y, 0, 1000)
    }
  end

  @spec change(t(), Change.t()) :: t()
  def change(position = %Position{}, %Change{attribute: attribute, direction: direction}) do
    delta = @move_deltas[attribute] / @fps * direction

    position
    |> Map.update!(attribute, Utils.add(delta))
    |> constrain_position()
  end

  @spec frame(t) :: t
  def frame(position = %Position{heading: heading, velocity: velocity, x: x, y: y}) do
    %Radian{radians: radians} = Radian.from_degrees(heading)

    x = x + velocity / @fps * :math.cos(radians)
    y = y + velocity / @fps * :math.sin(radians)

    position
    |> struct(x: x, y: y)
    |> constrain_position()
  end

  @spec change_from_key(t, Change.change_type(), possible_changes) :: t
  def change_from_key(position, key, possible_changes) do
    change_delta = possible_changes[key]

    case change_delta do
      nil -> position
      delta -> change(position, delta)
    end
  end
end
