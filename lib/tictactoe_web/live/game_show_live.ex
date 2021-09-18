defmodule TictactoeWeb.GameShowLive do
  use TictactoeWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias TictactoeWeb.GameChannel

  @impl true
  def render(%{game: %{x: x, o: o}} = assigns) when is_nil(x) or is_nil(o) do
    ~L"""
      <p class="text-gray-600">
        Waiting for a second player...
      </p>
    """
  end

  @impl true
  def render(%{game: nil} = assigns) do
    ~L"""
    <section class="game">
      <div class="msg">
        Connecting...
      </div>
    </section>
    """
  end

  @impl true
  def render(%{game: _game, error: nil} = assigns) do
    ~L"""
    <div>
      <div class="max-w-2xl mx-auto">
        <%= live_component @socket, TictactoeWeb.BoardComponent, id: :board, game: @game, player: @player %>
      </div>

      <section class="players text-gray-600">
        <div class="inline-block">
          <div class="player-name">
            <%= if @game.next == :x do %>
              <span class="turn x-turn">&#8680;</span>
            <% end %>

            <span><%= @game.x %></span>
          </div>
        </div>

        <div class="inline-block text-gray-600">
          <div class="player-name">
            <span><%= @game.o %></span>

            <%= if @game.next == :o do %>
              <span class="turn o-turn">&#8678;</span>
            <% end %>
          </div>
        </div>
      </section>

      <%= if @game.finished do %>
        <%= live_component @socket, TictactoeWeb.NewGameComponent, id: :new_game, game: @game %>
      <% end %>
    </div>
    """
  end

  @impl true
  def render(%{error: _error} = assigns) do
    ~L"""
    <section class="game">
      <div data-error class="alert alert-info">
        <%= @error %>
      </div>
    </section>
    """
  end

  @impl true
  def mount(%{"id" => game_name}, %{"player_name" => current_player}, socket) do
    if connected?(socket), do: join_player(game_name, current_player)

    {:ok,
     assign(socket,
       game: nil,
       game_name: game_name,
       player: %{name: current_player}
     )}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, push_redirect(socket, to: Routes.live_path(socket, TictactoeWeb.PlayerNewLive))}
  end

  defp join_player(game_name, current_player) do
    GameChannel.subscribe(game_name)

    game_name = Tictactoe.Engine.find_or_create_game(game_name)

    case Tictactoe.Engine.join_player(game_name, current_player) do
      {:ok, symbol, game_state} ->
        GameChannel.broadcast!(game_name, "new_player", %{game: game_state, symbol: symbol})

      {:error, message} ->
        assigns = %{error: message, game_name: game_name, current_player: current_player}
        GameChannel.broadcast!(game_name, "error", assigns)
    end
  end

  @impl true
  def handle_event("put_symbol", %{"index" => index}, socket) do
    %{game_name: game_name, player: player} = socket.assigns

    case Tictactoe.Engine.put_player_symbol(game_name, player.symbol, String.to_integer(index)) do
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

  @impl true
  def handle_event("new_round", _params, socket) do
    game_name = socket.assigns.game_name
    {:ok, new_game} = Tictactoe.Engine.new_round(game_name)

    GameChannel.broadcast!(game_name, "new_round", %{game: new_game})

    {:noreply, socket}
  end

  @impl true
  def handle_info(%Broadcast{event: "new_player", payload: %{game: game, symbol: symbol}}, socket) do
    player = Map.put_new(socket.assigns.player, :symbol, symbol)

    {:noreply, assign(socket, game: game, player: player, error: nil)}
  end

  @impl true
  def handle_info(%Broadcast{event: "error", payload: payload}, socket) do
    %{error: error, current_player: current_player} = payload

    if socket.assigns.player.name == current_player do
      {:noreply, assign(socket, error: error, game: nil)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(%Broadcast{event: "player_left", payload: %{game: game}}, socket) do
    {:noreply, assign(socket, game: game, error: nil)}
  end

  @impl true
  def handle_info(%Broadcast{event: "update_board", payload: %{game: game}}, socket) do
    {:noreply, assign(socket, game: game, error: nil)}
  end

  @impl true
  def handle_info(%Broadcast{event: "finish_game", payload: %{game: game}}, socket) do
    {:noreply, assign(socket, game: game, error: nil)}
  end

  @impl true
  def handle_info(%Broadcast{event: "new_round", payload: %{game: new_game}}, socket) do
    {:noreply, assign(socket, game: new_game, error: nil)}
  end

  @impl true
  def terminate(_reason, socket) do
    player = socket.assigns.player
    game_name = socket.assigns.game_name

    if Map.has_key?(player, :symbol) do
      {:ok, game} =
        game_name
        |> Tictactoe.Engine.find_or_create_game()
        |> Tictactoe.Engine.leave(player.symbol)

      GameChannel.broadcast!(game_name, "player_left", %{game: game})
    end
  end
end
