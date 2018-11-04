defmodule Broadside.Games.Coordinates do
  alias __MODULE__
  alias Broadside.Games.Radian

  @type t :: %Coordinates{
          x: number,
          y: number
        }

  defstruct x: 0, y: 0

  @spec from_angle(number, number) :: t
  def from_angle(magnitude, angle) do
    radians = Radian.from_degrees(angle)

    from_polar(magnitude, radians)
  end

  @spec to_angle_vector(t) :: {number, number}
  def to_angle_vector(%Coordinates{x: x, y: y}) do
    magnitude = :math.sqrt(x * x + y * y)

    angle =
      Radian.from_coordinates(x, y)
      |> Radian.to_degrees()

    {magnitude, angle}
  end

  @spec from_polar(number, Radian.t()) :: t
  def from_polar(magnitude, %Radian{radians: radians}) do
    x = magnitude * :math.cos(radians)
    y = magnitude * :math.sin(radians)

    %Coordinates{x: x, y: y}
  end

  def add(%Coordinates{x: x1, y: y1}, %Coordinates{x: x2, y: y2}) do
    %Coordinates{x: x1 + x2, y: y1 + y2}
  end
end
