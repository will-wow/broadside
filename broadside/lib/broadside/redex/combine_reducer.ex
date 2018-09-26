defmodule Redex.CombinedReducer do
  @moduledoc """
  Set up the action/store pipeline.

  reducers: shared data for all members of the channel
  user_reducer: one for each member of channel
  reactors: See reactor.ex

  Dispatch causes each user to get the shared state and their user state.
  """

  alias __MODULE__

  @type t :: %CombinedReducer{
          reducers: keyword,
          user_reducers: keyword,
          reactors: [atom]
        }

  defstruct reducers: [], user_reducers: [], reactors: []
end
