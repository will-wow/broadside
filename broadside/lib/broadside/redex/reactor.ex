defmodule Redex.Reactor do
  @moduledoc """
  Reactors are somewhere between components, thunks, and, sagas. Takes the whole store, the action, and is able to dispatch new actions. Runs after reducers have been updated.
  """
  alias Redex.Action

  @type store :: any
  @type dispatch :: (() -> none)

  # TODO: send in dispatch?
  @callback react(store :: store, action :: Action.t(), room_id :: any) :: any
end
