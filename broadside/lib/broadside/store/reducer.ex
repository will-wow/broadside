defmodule Broadside.Store.Reducer do
  @type state :: any

  @callback reduce() :: state
  @callback reduce(state :: state, action :: Action.t()) :: state
end
