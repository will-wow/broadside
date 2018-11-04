defmodule Broadside.Games.Radian do
  alias __MODULE__

  @type t :: %Radian{
          radians: float
        }

  defstruct radians: 0

  @one_eighty_over_pi 180 / :math.pi()
  @pi_over_one_eighty :math.pi() / 180
  @full_circle 2 * :math.pi()

  @spec new(number) :: t
  def new(n) do
    %Radian{radians: n}
  end

  @spec to_degrees(t) :: float
  def to_degrees(%Radian{radians: radians}) do
    radians * @one_eighty_over_pi
  end

  @spec from_degrees(number) :: t
  def from_degrees(degrees) do
    radians = degrees * @pi_over_one_eighty

    %Radian{radians: radians}
  end

  @spec from_coordinates(number, number) :: t
  def from_coordinates(x, y) do
    radians =
      case x >= 0 do
        true -> :math.atan(y / x)
        false -> :math.atan(y / x) + :math.pi()
      end

    %Radian{radians: radians}
    |> normalize()
  end

  defp normalize(%Radian{radians: radians}) do
    cond do
      radians < 0 ->
        (radians + @full_circle)
        |> new()
        |> normalize()

      radians >= @full_circle ->
        (radians - @full_circle)
        |> new()
        |> normalize()

      true ->
        radians
        |> new()
    end
  end
end
