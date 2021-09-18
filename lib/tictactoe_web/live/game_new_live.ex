defmodule TictactoeWeb.GameNewLive do
  use TictactoeWeb, :live_view

  alias TictactoeWeb.{PlayerNewLive, GameShowLive}

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <div class="md:w-3/6 mx-auto mt-40 p-5">
        <%= f = form_for @changeset, "#", as: :game, class: "grid grid-cols-12", phx_submit: "create_game" %>
          <div class="col-span-9">
            <%= text_input f, :name, placeholder: "Create a new game...", autofocus: true, class: "w-full border-b border-gray-300" %>
          </div>

          <div class="col-span-3">
            <%= submit "Start", class: "w-full border border-blue-500 px-4 py-2 bg-blue-500 text-blue-100" %>
          </div>
        </form>

        <div class="mt-5">
          <div>
            <%= if length(@games) > 0 do %>
              <p class="text-xl text-gray-500">
                Or join one of the games below:
              </p>
            <% end %>
            <ul class="ml-5 mt-2 text-gray-500">
              <%= for game <- @games do %>
                <li class="list-disc">
                  <%= live_redirect game, to: Routes.live_path(@socket, TictactoeWeb.GameShowLive, game) %>
                </li>
              <% end %>
            </ul>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, %{"player_name" => _player_name}, socket) do
    Tictactoe.Engine.subscribe(~w(game_created game_closed)a)
    changeset = build_game_changeset(%{})

    {:ok, assign(socket, games: Tictactoe.Engine.active_games(), changeset: changeset)}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, push_redirect(socket, to: Routes.live_path(socket, PlayerNewLive))}
  end

  @impl true
  def handle_event("create_game", %{"game" => game_params}, socket) do
    changeset = build_game_changeset(game_params)

    if changeset.valid? do
      game = Ecto.Changeset.apply_changes(changeset)
      path = Routes.live_path(socket, GameShowLive, game.name)

      {:noreply, push_redirect(socket, to: path)}
    else
      # TODO: handle errors
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:game_engine_event, :game_created}, socket) do
    {:noreply, assign(socket, games: Tictactoe.Engine.active_games())}
  end

  @impl true
  def handle_info({:game_engine_event, :game_closed}, socket) do
    {:noreply, assign(socket, games: Tictactoe.Engine.active_games())}
  end

  defp build_game_changeset(params) do
    types = %{name: :string}

    {%{}, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required(:name)
  end
end
