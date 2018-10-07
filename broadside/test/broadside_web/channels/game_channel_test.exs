defmodule BroadsideWeb.GameChannelTest do
  use BroadsideWeb.ChannelCase

  alias Broadside.Games.GameSupervisor
  alias BroadsideWeb.GameChannel
  alias Broadside.Accounts
  alias Broadside.Games.GameSupervisor
  alias BroadsideWeb.GameView

  setup do
    {:ok, game_id} = GameSupervisor.start_game()

    secret = "this is a secret this is a secret"

    user_id = Accounts.new_user()
    token = Accounts.new_token(secret, user_id)

    {:ok, _, socket} =
      socket("user", %{token: token, user_id: user_id})
      |> subscribe_and_join(GameChannel, "game:#{game_id}")

    %{
      game_id: game_id,
      socket: socket,
      token: token,
      user_id: user_id
    }
  end

  test "broadcast the game state a socket", %{
    game_id: game_id,
    socket: socket
  } do
    {:ok, game} = GameSupervisor.get_game_state(game_id)

    rendered_game = GameView.render("show.json", game)

    GameChannel.broadcast_game_state(socket, game)

    assert_broadcast("game_state", ^rendered_game)
  end

  test "broadcast the game state without a socket", %{
    game_id: game_id
  } do
    {:ok, game} = GameSupervisor.get_game_state(game_id)

    rendered_game = GameView.render("show.json", game)

    GameChannel.broadcast_game_state(game)

    assert_broadcast("game_state", ^rendered_game)
  end
end
