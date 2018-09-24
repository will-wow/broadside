defmodule Utils do
  @spec clamp(number, number, number) :: number
  def clamp(n, min, max) do
    cond do
      n < min -> min
      n > max -> max
      true -> n
    end
  end

  @spec add(number) :: (number -> number)
  def add(n2), do: fn n1 -> n1 + n2 end
  @spec subtract(number) :: (number -> number)
  def subtract(n2), do: fn n1 -> n1 - n2 end

  @spec mod(number, number) :: float
  def mod(f1, f2) do
    f1 - f2 * Float.floor(f1 / f2)
  end

  @spec identity(x) :: x when x: var
  def identity(x), do: x
end
