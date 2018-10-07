defmodule BroadsideWeb.GameView do
  use BroadsideWeb, :view

  alias Broadside.Games.Game
  alias Redex.Transform

  def render(
        "show.json",
        game = %Game{
          id: id,
          fps: fps,
          bullets: bullets
        }
      ) do
    %{
      id: id,
      fps: fps,
      bullets: bullets,
      score: Game.score(game),
      ships: Game.ships(game)
    }
    |> Transform.to_json()
  end
end
