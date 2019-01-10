require Protocol
Protocol.derive(Jason.Encoder, GameEngine.Game)
Protocol.derive(Jason.Encoder, GameEngine.Board)

defmodule GameUiWeb.GameChannel do
  use Phoenix.Channel

  def join("game:" <> name, _params, socket) do
    game = GameEngine.find_or_create_game(name)

    case GameEngine.join_player(game, socket.assigns.player) do
      {:ok, symbol, game_state} ->
        send(self(), {:after_join, game_state})

        socket =
          socket
          |> assign(:game, name)
          |> assign(:symbol, symbol)

        {:ok, game_state, socket}

      {:error, message} ->
        {:error, %{reason: message}}
    end
  end

  def handle_in("put", %{"index" => index}, socket) do
    game = GameEngine.find_or_create_game(socket.assigns.game)

    case GameEngine.put_player_symbol(game, socket.assigns.symbol, String.to_integer(index)) do
      {:ok, game_state} ->
        broadcast!(socket, "update_board", game_state)

      {:draw, game_state} ->
        broadcast!(socket, "finish_game", game_state)

      {:winner, game_state} ->
        broadcast!(socket, "finish_game", game_state)

      _ ->
        :ok
    end

    {:noreply, socket}
  end

  def handle_in("new_round", _params, socket) do
    game = GameEngine.find_or_create_game(socket.assigns.game)
    new_game = GameEngine.new_round(game)

    broadcast!(socket, "new_round", new_game)

    {:noreply, socket}
  end

  def handle_info({:after_join, game_state}, socket) do
    broadcast!(socket, "new_player", game_state)
    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    game = GameEngine.find_or_create_game(socket.assigns.game)

    GameEngine.leave(game, socket.assigns.symbol)

    broadcast!(socket, "player_left", %{})
  end
end
