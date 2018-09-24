defmodule Broadside.Radian do
  alias __MODULE__

  @type t :: %Radian{
          radians: float
        }

  defstruct radians: 0

  @one_eighty_over_pi 180 / :math.pi()
  @pi_over_one_eighty :math.pi() / 180

  @spec to_degrees(t) :: float
  def to_degrees(%Radian{radians: radians}) do
    radians * @one_eighty_over_pi
  end

  @spec from_degrees(number) :: t
  def from_degrees(degrees) do
    radians = degrees * @pi_over_one_eighty

    %Radian{radians: radians}
  end
end
