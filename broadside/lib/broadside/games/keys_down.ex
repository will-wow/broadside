defmodule Broadside.Games.KeysDown do
  alias __MODULE__

  @type keys :: %{optional(String.t()) => boolean}

  @type t :: %KeysDown{
          keys: map
        }

  defstruct keys: %{}

  @spec new(keys) :: t
  def new(keys) when is_map(keys) do
    %KeysDown{keys: keys}
  end

  @spec new(keyword) :: t
  def new(keys) when is_list(keys) do
    keys
    |> Enum.into(%{})
    |> new()
  end

  @spec record_key_change(
          keys_down :: t,
          event :: :down | :up,
          key :: String.t()
        ) :: t
  def record_key_change(keys_down, event, key) do
    case event do
      :up -> record_key_up(keys_down, key)
      :down -> record_key_down(keys_down, key)
    end
  end

  @spec pressed_keys(t) :: [String.t()]
  def pressed_keys(keys_down) do
    keys_down
    |> filter_keys_down()
    |> Map.fetch!(:keys)
    |> Map.keys()
  end

  @spec record_key_down(keys_down :: t, key :: String.t()) :: t
  defp record_key_down(keys_down, key) do
    keys_down.keys
    |> Map.put(key, true)
    |> new()
  end

  @spec record_key_up(t, String.t()) :: t
  defp record_key_up(keys_down, key) do
    keys_down.keys
    |> Map.put(key, false)
    |> new()
  end

  @spec filter_keys_down(t) :: t
  defp filter_keys_down(%KeysDown{keys: keys}) do
    keys
    |> Enum.filter(fn {_, down} -> down end)
    |> new()
  end
end
