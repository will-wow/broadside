defmodule BroadsideWeb.GameView do
  use BroadsideWeb, :view

  alias Broadside.Games.Game
  alias Redex.Transform

  def render(
        "show.json",
        game = %Game{
          fps: fps,
          bullets: bullets
        }
      ) do
    %{
      fps: fps,
      bullets: bullets,
      ships: Game.ships(game)
    }
    |> Transform.to_json()
  end
end
