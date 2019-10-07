defmodule GameUiWeb.GameLive do
  use Phoenix.LiveView

  alias Phoenix.Socket.Broadcast
  alias GameUiWeb.{GameView, GameChannel}

  def render(%{game: _game, error: nil} = assigns) do
    GameView.render("show.html", assigns)
  end

  def render(%{error: _error} = assigns) do
    ~L"""
    <section class="game">
      <div data-error class="alert alert-info">
        <%= @error %>
      </div>
    </section>
    """
  end

  def render(%{game: nil} = assigns) do
    ~L"""
    <section class="game">
      <div class="msg">
        Connecting...
      </div>
    </section>
    """
  end

  def mount(session, socket) do
    if connected?(socket), do: join_player(session)

    {:ok, assign(socket, game: nil, game_name: session.game_name, player: %{name: session.current_player})}
  end

  defp join_player(%{game_name: game_name, current_player: current_player}) do
    GameChannel.subscribe(game_name)

    game_name = GameEngine.find_or_create_game(game_name)

    case GameEngine.join_player(game_name, current_player) do
      {:ok, symbol, game_state} ->
        GameChannel.broadcast!(game_name, "new_player", %{game: game_state, symbol: symbol})

      {:error, message} ->
        assigns = %{error: message, game_name: game_name, current_player: current_player}
        GameChannel.broadcast!(game_name, "error", assigns)
    end
  end

  def handle_event("put_symbol", %{"index" => index}, socket) do
    %{game_name: game_name, player: player} = socket.assigns

    case GameEngine.put_player_symbol(game_name, player.symbol, String.to_integer(index)) do
      {:ok, game_state} ->
        GameChannel.broadcast!(game_name, "update_board", %{game: game_state})

      {:draw, game_state} ->
        GameChannel.broadcast!(game_name, "finish_game", %{game: game_state})

      {:winner, game_state} ->
        GameChannel.broadcast!(game_name, "finish_game", %{game: game_state})

      _ ->
        :ok
    end

    {:noreply, socket}
  end

  def handle_event("new_round", _params, socket) do
    game_name = socket.assigns.game_name
    {:ok, new_game} = GameEngine.new_round(game_name)

    GameChannel.broadcast!(game_name, "new_round", %{game: new_game})

    {:noreply, socket}
  end

  def handle_info(%Broadcast{event: "new_player", payload: %{game: game, symbol: symbol}}, socket) do
    player = Map.put_new(socket.assigns.player, :symbol, symbol)

    {:noreply, assign(socket, game: game, player: player, error: nil)}
  end

  def handle_info(%Broadcast{event: "error", payload: payload}, socket) do
    %{error: error, current_player: current_player} = payload

    if socket.assigns.player.name == current_player do
      {:noreply, assign(socket, error: error, game: nil)}
    else
      {:noreply, socket}
    end
  end

  def handle_info(%Broadcast{event: "player_left", payload: %{game: game}}, socket) do
    {:noreply, assign(socket, game: game, error: nil)}
  end

  def handle_info(%Broadcast{event: "update_board", payload: %{game: game}}, socket) do
    {:noreply, assign(socket, game: game, error: nil)}
  end

  def handle_info(%Broadcast{event: "finish_game", payload: %{game: game}}, socket) do
    {:noreply, assign(socket, game: game, error: nil)}
  end

  def handle_info(%Broadcast{event: "new_round", payload: %{game: new_game}}, socket) do
    {:noreply, assign(socket, game: new_game, error: nil)}
  end

  def terminate(_reason, socket) do
    player = socket.assigns.player
    game_name = socket.assigns.game_name

    if Map.has_key?(player, :symbol) do
      {:ok, game} =
        game_name
        |> GameEngine.find_or_create_game()
        |> GameEngine.leave(player.symbol)

      GameChannel.broadcast!(game_name, "player_left", %{game: game})
    end
  end
end
