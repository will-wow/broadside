defmodule Broadside.Store.CombinedReducer do
  alias Broadside.Store.CombinedReducer

  @type t :: %CombinedReducer{
          reducers: [atom],
          user_reducers: [atom]
        }

  defstruct reducers: [], user_reducers: []

  def new(reducers, user_reducers \\ []) do
    %CombinedReducer{
      reducers: reducers,
      user_reducers: user_reducers
    }
  end
end
