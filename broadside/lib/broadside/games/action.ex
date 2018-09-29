defmodule Broadside.Games.Action do
  alias __MODULE__
  @type t :: Action.KeyChange.t() | Action.Frame.t() | Action.PlayerJoin.t()

  @spec from_params(map | keyword) :: t
  def from_params(params) do
    type = params["type"]
    data = params["data"] |> parse_data()

    type
    |> String.to_existing_atom()
    |> struct!(data)
  end

  defp parse_data(data) do
    data
    |> Enum.map(fn {key, value} ->
      {
        String.to_existing_atom(key),
        value
      }
    end)
  end

  defmodule KeyChange do
    alias Broadside.Id

    @type t :: %__MODULE__{
            event: :up | :down,
            key: String.t(),
            user_id: Id.t()
          }
    defstruct [:event, :key, :user_id]
  end

  defmodule Frame do
    @type t :: %__MODULE__{}
    defstruct []
  end

  defmodule PlayerJoin do
    alias Broadside.Id

    @type t :: %__MODULE__{user_id: Id.t()}
    defstruct [:user_id]
  end

  # TODO:
  defmodule Event do
    @spec define(atom, keyword, keyword) :: any
    defmacro define(name, types, defaults \\ []) do
      IO.inspect(name)

      fields =
        Enum.map(types, fn {name, _} ->
          {name, defaults[name]}
        end)

      quote do
        defmodule unquote(name) do
          defstruct unquote(fields)
          @type t :: struct(unquote(name), unquote(types))
        end
      end
    end
  end
end
