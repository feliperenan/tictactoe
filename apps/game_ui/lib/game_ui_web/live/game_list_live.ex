defmodule GameUiWeb.GameListLive do
  use Phoenix.LiveView

  import Phoenix.HTML.Link, only: [link: 2]

  alias GameUiWeb.Router.Helpers, as: Routes

  @impl true
  def render(assigns) do
    ~L"""
    <ul class="game-list">
    <%= for game <- @games do %>
      <li class="game-list__item">
        <%= link game, to: Routes.game_path(@socket, :show, game), class: "game-list__link" %>
      </li>
      <% end %>
    </ul>
    """
  end

  @impl true
  def mount(_session, socket) do
    GameEngine.subscribe(~w(game_created game_closed)a)

    {:ok, assign(socket, games: GameEngine.active_games())}
  end

  @impl true
  def handle_info({:game_engine_event, :game_created}, socket) do
    {:noreply, assign(socket, games: GameEngine.active_games())}
  end

  @impl true
  def handle_info({:game_engine_event, :game_closed}, socket) do
    {:noreply, assign(socket, games: GameEngine.active_games())}
  end
end
