defmodule Broadside.Store.Reducer do
  alias Broadside.Store.Reducer.NoUpdate
  alias Broadside.Store.Reducer.Update
  alias Broadside.Store.Reducer.SideEffects
  alias Broadside.Store.Reducer.UpdateWithSideEffects

  @type return :: NoUpdate.t() | Update.t() | SideEffects.t() | UpdateWithSideEffects.t()
  @type state :: any

  @callback reduce() :: state
  @callback reduce(state :: state, action :: Action.t()) :: return
end
