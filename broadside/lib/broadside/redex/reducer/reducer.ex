defmodule Redex.Reducer do
  alias Redex.Action
  alias Redex.Reducer.NoUpdate
  alias Redex.Reducer.Update
  alias Redex.Reducer.SideEffects
  alias Redex.Reducer.UpdateWithSideEffects

  @type return_value(state) ::
          NoUpdate.t(state) | Update.t(state) | SideEffects.t(state) | UpdateWithSideEffects.t()

  @callback reduce(state, Action.t()) :: return_value(state) when state: var

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

      @impl true
      def init(_) do
        {:ok, %__MODULE__{}}
      end

      @impl true
      def handle_call({:apply_action, action}, _from, state) do
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
