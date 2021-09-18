defmodule TictactoeWeb.LogoutController do
  use TictactoeWeb, :controller

  def delete(conn, _params) do
    session = get_session(conn, :session_uuid)

    conn
    |> delete_session_token(session)
    |> clear_session()
    |> configure_session(drop: true)
    |> redirect(to: Routes.live_path(conn, TictactoeWeb.PlayerNewLive))
  end

  def delete_session_token(conn, nil), do: conn

  def delete_session_token(conn, session_uuid) do
    TictactoeWeb.PlayerETS.delete_player(session_uuid)
    conn
  end
end
