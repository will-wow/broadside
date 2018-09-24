defmodule Broadside.Games.Constants do
  @fps 10
  @milliseconds_per_frame round(1000 / @fps)
  @max_speed 60

  def get(:fps), do: @fps
  def get(:ms_per_frame), do: @milliseconds_per_frame
  def get(:max_speed), do: @max_speed
end
