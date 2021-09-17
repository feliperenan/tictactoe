defmodule GameUiWeb.GameListLive do
  use Phoenix.LiveView

  import Phoenix.HTML.Link, only: [link: 2]

  alias GameUiWeb.Router.Helpers, as: Routes

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <%= if length(@games) > 0 do %>
        <p class="text-xl text-gray-500">
          Or join one of the games below:
        </p>
      <% end %>
      <ul class="ml-5 mt-2 text-gray-500">
      <%= for game <- @games do %>
        <li class="list-disc">
          <%= link game, to: Routes.game_path(@socket, :show, game), class: "game-list__link" %>
        </li>
        <% end %>
      </ul>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
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
