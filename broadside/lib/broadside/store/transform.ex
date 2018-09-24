defmodule Broadside.Store.Transform do
  @spec to_json(term) :: term
  def to_json(%_{} = struct) do
    struct
    |> Map.from_struct()
    |> to_json()
  end

  def to_json(data) when is_map(data) do
    data
    |> Enum.map(fn {key, value} ->
      key = transform_key(key)
      value = to_json(value)
      {key, value}
    end)
    |> Enum.into(%{})
  end

  def to_json(data) when is_list(data) do
    data
    |> Enum.map(&to_json/1)
  end

  def to_json(data) when is_tuple(data) do
    data
    |> Tuple.to_list()
    |> to_json()
  end

  def to_json(data) do
    data
  end

  @spec transform_key(atom | String.t()) :: String.t()
  defp transform_key(key) when is_atom(key) do
    key
    |> Atom.to_string()
    |> transform_key()
  end

  defp transform_key(key) when is_binary(key) do
    case key
         |> String.split("_") do
      [] ->
        ""

      [leading | trailing] ->
        trailing = Enum.map(trailing, &String.capitalize/1)

        [leading | trailing]
        |> Enum.join()
    end
  end
end
