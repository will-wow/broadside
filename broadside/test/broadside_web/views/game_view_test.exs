defmodule BroadsideWeb.GameViewTest do
  use ExUnit.Case, async: true

  alias BroadsideWeb.GameView
  alias Broadside.Games.Game
  alias Broadside.Games.UserState

  test "formats a game" do
    game = %Game{
      id: "game_1",
      fps: 10,
      bullets: [],
      users: %{
        "alice" => UserState.new("alice"),
        "bob" => UserState.new("bob")
      }
    }

    assert %{
             "bullets" => [],
             "fps" => 10,
             "id" => "game_1",
             "score" => [
               {"alice", 0},
               {"bob", 0}
             ],
             "ships" => [
               %{"id" => "alice"},
               %{"id" => "bob"}
             ]
           } = GameView.render("show.json", game)
  end
end
