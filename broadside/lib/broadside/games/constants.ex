defmodule Broadside.Games.Constants do
  @constants %{
    fps: 10,
    ms_per_frame: round(1000 / 10),
    max_speed: 60,
    max_x: 1000,
    max_y: 1000
  }

  @spec get(atom | [atom]) :: any
  def get(attribute) when is_atom(attribute) do
    @constants[attribute]
  end

  def get(attributes) when is_list(attributes) do
    Map.take(@constants, attributes)
  end
end
