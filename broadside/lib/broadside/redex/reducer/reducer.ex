defmodule Redex.Reducer do
  alias Redex.Reducer.NoUpdate
  alias Redex.Reducer.Update
  alias Redex.Reducer.SideEffects
  alias Redex.Reducer.UpdateWithSideEffects

  @type return_value :: NoUpdate.t() | Update.t() | SideEffects.t() | UpdateWithSideEffects.t()
  @type state :: any

  @callback reduce() :: state
  @callback reduce(state :: state, action :: Action.t()) :: return_value

  defmacro __using__(_) do
    quote do
      use GenServer

      alias Redex.Reducer
      alias Redex.Reducer.NoUpdate
      alias Redex.Reducer.Update
      alias Redex.Reducer.SideEffects
      alias Redex.Reducer.UpdateWithSideEffects

      @behaviour Reducer

      def start_link(opts) do
        GenServer.start_link(__MODULE__, [], opts)
      end

      def apply_action(pid, action) do
        GenServer.call(pid, {:apply_action, action})
      end

      def init(_) do
        {:ok, reduce()}
      end

      def handle_call({:apply_action, action}, state) do
        case reduce(state, action) do
          %NoUpdate{} ->
            {:reply, state, state}

          %Update{state: new_state} ->
            {:reply, new_state, new_state}

          %SideEffects{f: f} ->
            f.(state)
            {:reply, state, state}

          %UpdateWithSideEffects{state: new_state, f: f} ->
            f.(state)
            {:reply, new_state, new_state}
        end
      end
    end
  end
end
