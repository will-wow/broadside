defmodule Broadside.Games.Position do
  alias __MODULE__
  alias __MODULE__.Change
  alias Broadside.Games.Radian
  alias Broadside.Games.Coordinates
  alias Broadside.Games.Constants

  @type t :: %Position{
          x: number,
          y: number,
          velocity: number,
          max_velocity: number,
          heading: number,
          radius: number
        }

  @type possible_changes :: %{optional(String.t()) => Change.t()}

  defstruct radius: 1.0, x: 0.0, y: 0.0, velocity: 0.0, max_velocity: 0.0, heading: 0.0

  @fps Constants.get(:fps)
  @max_x Constants.get(:max_x)
  @max_y Constants.get(:max_y)

  @move_deltas %{
    heading: 45,
    velocity: 10
  }

  @spec random_start(keyword) :: t
  def random_start(args \\ []) do
    %Position{
      heading: Enum.random(0..359),
      x: Enum.random(0..@max_x),
      y: Enum.random(0..@max_y)
    }
    |> struct!(args)
  end

  @spec constrain_position(t) :: t
  def constrain_position(
        position = %Position{
          heading: heading,
          velocity: velocity,
          x: x,
          y: y,
          max_velocity: max_velocity
        }
      ) do
    %Position{
      position
      | heading: heading,
        velocity:
          Utils.clamp(
            velocity,
            -max_velocity,
            max_velocity
          ),
        x: Utils.clamp(x, 0, @max_x),
        y: Utils.clamp(y, 0, @max_y)
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

  @spec perpendicular(t, :left | :right, number, keyword) :: t
  def perpendicular(
        %Position{x: x, y: y, heading: heading, velocity: velocity},
        side,
        perpendicular_velocity,
        args
      ) do
    heading_delta =
      case side do
        :left -> -90
        :right -> 90
      end

    perpendicular_heading = heading + heading_delta

    c1 = Coordinates.from_angle(velocity, heading)
    c2 = Coordinates.from_angle(perpendicular_velocity, perpendicular_heading)

    {new_velocity, new_heading} =
      c1
      |> Coordinates.add(c2)
      |> Coordinates.to_angle_vector()

    %Position{
      x: x,
      y: y,
      heading: new_heading,
      velocity: new_velocity
    }
    |> struct!(args)
  end

  @spec collision?(t, t) :: boolean
  def collision?(position1 = %Position{}, position2 = %Position{}) do
    distance(position1, position2) <= position1.radius + position2.radius
  end

  @spec distance(t, t) :: float
  def distance(position1 = %Position{}, position2 = %Position{}) do
    :math.sqrt(:math.pow(position1.x - position2.x, 2) + :math.pow(position1.y - position2.y, 2))
  end
end
