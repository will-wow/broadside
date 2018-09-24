defmodule Broadside.Games.FrameInterval do
  use GenServer

  alias __MODULE__

  defstruct [:on_tick, :interval]

  @type state :: %FrameInterval{
          on_tick: (() -> any),
          interval: integer
        }

  @interval Kernel.round(1000 / 24)

  alias __MODULE__

  @spec start_link(keyword) :: GenServer.on_start()
  def start_link(opts) do
    name = opts[:name]
    on_tick = opts[:on_tick]
    interval = opts[:interval] || @interval

    GenServer.start_link(FrameInterval, {on_tick, interval}, name: name)
  end

  def init({on_tick, interval}) do
    state = %FrameInterval{
      on_tick: on_tick,
      interval: interval
    }

    schedule_interval(state)
    {:ok, state}
  end

  def handle_info(:tick, state) do
    schedule_interval(state)
    {:noreply, state}
  end

  defp schedule_interval(state) do
    state.on_tick.()

    Process.send_after(self(), :tick, state.interval)
  end
end
