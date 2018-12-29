defmodule GameUiWeb.PlayerController do
  use GameUiWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"player" => player_params}) do
    player = Map.get(player_params, "name", "Anonymous")

    conn
    |> set_player(player)
    |> redirect(to: game_path(conn, :new))
  end

  defp set_player(conn, player) do
    conn
    |> assign(:current_player, player)
    |> put_session(:current_player, player)
    |> configure_session(renew: true)
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: player_path(conn, :new))
  end
end
