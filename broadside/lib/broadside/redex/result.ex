defmodule Result do
  @moduledoc """
  Types and functions for {:ok, data} | {:error, msg} tuples.
  """

  @type t(success, failure) :: {:ok, success} | {:error, failure}
  @type generic :: t(any, any)

  @doc """
  Takes a Result and a mapping function. If the result is an :ok,
  applies the function to the data payload
  and wraps the result in an {:ok, data}.
  If the result is an :error, passes the Result through.
  """
  @spec map_ok(result :: generic, f :: (any -> any)) :: generic
  def map_ok({:ok, data}, f), do: {:ok, f.(data)}
  def map_ok({:error, msg}, _f), do: {:error, msg}

  @doc """
  Takes a Result and a mapping function. If the result is an :error,
  applies the function to the message
  and wraps the result in an {:error, message}.
  If the result is an :ok, passes the Result through.
  """
  @spec map_error(result :: generic, f :: (any -> any)) :: generic
  def map_error({:ok, data}, _f), do: {:ok, data}
  def map_error({:error, msg}, f), do: {:error, f.(msg)}

  @doc """
  Takes a Result and an error message. If the result is an :error,
  replaces the error's message with the new message.
  If the result is an :ok, passes the Result through.
  """
  @spec replace_error(result :: generic, msg :: any) :: generic
  def replace_error({:ok, data}, _), do: {:ok, data}
  def replace_error({:error, _}, msg), do: {:error, msg}

  @doc """
  Takes a Result and a mapping function that returns a result.
  If the result is an :ok, applies the function to the message
  and returns the result.
  If the result is an :error, passes the Result through.
  """
  @spec flat_map_ok(result :: generic, f :: (any -> generic)) :: generic
  def flat_map_ok({:ok, data}, f), do: f.(data)
  def flat_map_ok(result = {:error, _msg}, _f), do: result

  @doc """
  Takes a Result and a mapping function that returns a result.
  If the result is an :error, applies the function to the message
  and returns the result.
  If the result is an :ok, passes the Result through.
  """
  @spec flat_map_error(result :: generic, f :: (any -> generic)) :: generic
  def flat_map_error(result = {:ok, _data}, _f), do: result
  def flat_map_error({:error, msg}, f), do: f.(msg)

  @doc """
  Takes a list of Results. If all are {:ok, _}, returns {:ok, nil}. If any are {:error, msg}, returns the first {:error, msg}.
  """
  @spec all_ok(results :: [generic]) :: generic
  def all_ok(results) do
    results
    |> Enum.find({:ok, nil}, fn
      {:ok, _} -> false
      {:error, _} -> true
    end)
  end

  @doc """
  Takes a list of Results. If all are {:ok, _}, returns :ok. If any are {:error, msg}, throws msg
  """
  @spec all_ok!(results :: [generic]) :: generic
  def all_ok!(results) do
    case all_ok(results) do
      {:ok, _} -> :ok
      {:error, msg} -> raise msg
    end
  end

  @doc """
  Takes a list of Results. If all are {:ok, data}, collects the data in a list and returns {:ok, [data]}. If any are {:error, msg}, returns the first {:error, msg}.
  """
  @spec collect_oks(results :: [generic]) :: generic
  def collect_oks(results) do
    results
    |> Enum.reduce_while({:ok, []}, fn result, {:ok, acc} ->
      case result do
        {:ok, data} -> {:cont, {:ok, [data | acc]}}
        {:error, msg} -> {:halt, {:error, msg}}
      end
    end)
    |> map_ok(&Enum.reverse/1)
  end

  @doc """
  Takes a list of Results. If all are {:ok, data}, collects the data in a list and returns [data]. If any are {:error, msg}, throws msg as an error.
  """
  @spec collect_oks!(results :: [generic]) :: [any]
  def collect_oks!(results) do
    case collect_oks(results) do
      {:ok, data} -> data
      {:error, msg} -> raise msg
    end
  end
end
