defmodule Broadside.Position do
  alias __MODULE__
  alias __MODULE__.Change
  alias Broadside.Radian

  @type t :: %Position{
          x: number,
          y: number,
          velocity: number,
          heading: number
        }

  @type possible_changes :: %{optional(String.t()) => Change.t()}

  defstruct x: 0.0, y: 0.0, velocity: 0.0, heading: 0.0

  @move_deltas %{
    heading: 0.25,
    velocity: 3
  }

  def constrain_position(%Position{heading: heading, velocity: velocity, x: x, y: y}) do
    %Position{
      heading: Utils.mod(heading, 360),
      velocity: Utils.clamp(velocity, -9, 9),
      x: Utils.clamp(x, 0, 1000),
      y: Utils.clamp(y, 0, 1000)
    }
  end

  @spec change(t(), Change.t()) :: t()
  def change(position = %Position{}, %Change{attribute: attribute, direction: direction}) do
    delta = @move_deltas[attribute] * direction

    position
    |> Map.update!(attribute, Utils.add(delta))
    |> constrain_position()
  end

  @spec turn(t) :: t
  def turn(position = %Position{heading: heading, velocity: velocity, x: x, y: y}) do
    %Radian{radians: radians} = Radian.from_degrees(heading)

    x = x + velocity / 24 * :math.cos(radians)
    y = y + velocity / 24 * :math.sin(radians)

    position
    |> struct(x: x, y: y)
    |> constrain_position()
  end

  @spec change_from_key(t, Change.change_type(), possible_changes) :: t
  def change_from_key(position, key, possible_changes) do
    IO.inspect({"Change from ey", key})
    change_delta = possible_changes[key]

    case change_delta do
      nil -> position
      delta -> change(position, delta)
    end
  end
end
