defmodule Broadside.Store.Reactor do
  @moduledoc """
  Reactors are like components/sagas. Takes the whole store, and the action, and is able to dispatch new actions. Runs after reducers have been updated.

  TODO: What happens if store is updated in the meantime?
  """
  alias Broadside.Store.Action

  @type store :: any
  @type dispatch :: (() -> none)

  # TODO: send in dispatch?
  @callback react(store :: store, action :: Action.t()) :: none
end
