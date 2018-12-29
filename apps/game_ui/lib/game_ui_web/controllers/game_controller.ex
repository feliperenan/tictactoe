defmodule GameUiWeb.GameController do
  use GameUiWeb, :controller

  plug :check_player

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"game" => game_params}) do
    case Map.get(game_params, "name") do
      nil ->
        conn
        |> put_flash(:error, "Game cannot be empty")
        |> render("new.html")

      name ->
        redirect(conn, to: game_path(conn, :show, name))
    end
  end

  def show(conn, %{"name" => name}) do
    render(conn, "show.html", name: name)
  end

  defp check_player(conn, _options) do
    if conn.assigns.current_player do
      conn
    else
      conn
      |> put_flash(:error, "You must configure a player to get into a game")
      |> redirect(to: player_path(conn, :new))
      |> halt()
    end
  end
end
