defmodule TictactoeWeb.PlayerNewLive do
  use TictactoeWeb, :live_view

  alias TictactoeWeb.GameNewLive
  alias TictactoeWeb.Player

  def render(assigns) do
    ~L"""
    <div class="md:w-3/6 mx-auto mt-40 p-5">
      <p class="mb-5 text-xl text-gray-600">
        Let's play Tic-Tac-Toe?
      </p>
      <%= f = form_for @changeset, "#", as: :player, class: "grid grid-cols-12", phx_submit: "save"  %>
        <div class="col-span-9">
          <%= text_input f,
                :name,
                placeholder: "First, enter your name here...",
                autofocus: true,
                class: "w-full border-b border-gray-300" %>
        </div>

        <div class="col-span-3">
          <%= submit "Submit", class: "w-full border border-blue-500 px-4 py-2 bg-blue-700 text-blue-100" %>
        </div>
      </form>
    </div>
    """
  end

  def mount(_params, %{"player_name" => _player_name}, socket) do
    {:ok, push_redirect(socket, to: Routes.live_path(socket, GameNewLive))}
  end

  def mount(_params, %{"session_uuid" => session_uuid}, socket) do
    player = %Player{uuid: session_uuid}
    changeset = Player.changeset(player)

    {:ok, assign(socket, changeset: changeset, player: player)}
  end

  def handle_event("save", %{"player" => player_params}, socket) do
    changeset = Player.changeset(socket.assigns.player, player_params)

    if changeset.valid? do
      player = Ecto.Changeset.apply_changes(changeset)
      TictactoeWeb.PlayerETS.insert_player(player)

      {:noreply, redirect(socket, to: Routes.live_path(socket, GameNewLive))}
    else
      {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
