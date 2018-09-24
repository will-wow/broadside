defmodule Broadside.Games.FrameIntervalTest do
  use ExUnit.Case, async: true

  alias Broadside.Games.FrameInterval

  test "sends out ticks" do
    test_pid = self()

    FrameInterval.start_link(
      on_tick: fn ->
        send(test_pid, :on_tick)
      end,
      interval: 1
    )

    assert_received :on_tick
    refute_received :on_tick

    Process.sleep(1)

    assert_received :on_tick
    refute_received :on_tick

    Process.sleep(1)

    assert_received :on_tick
    refute_received :on_tick
  end
end
