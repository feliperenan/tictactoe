defmodule TictactoeWeb.Plugs.Session do
  @moduledoc """
  This Plug is responsible for setting a User session in the back-end using `PlayerETS`.

  This is required because this project uses Phoenix Live View which works on top of websocket and,
  because of that it is not possible to manipulate the User's session.

  This approach is inspired by this blog post:

  https://toranbillups.com/blog/archive/2020/06/26/cookie-authentication-with-phoenix-liveview/
  """
  import Plug.Conn

  alias TictactoeWeb.PlayerETS

  require Logger

  def init(options) do
    options
  end

  def call(conn, _opts) do
    case get_session(conn, :session_uuid) do
      nil ->
        put_session(conn, :session_uuid, Ecto.UUID.generate())

      session_uuid ->
        player_name = PlayerETS.find_player(session_uuid)

        put_player_in_session(conn, player_name)
    end
  end

  defp put_player_in_session(conn, nil), do: conn

  defp put_player_in_session(conn, player_name) do
    conn
    |> assign(:player_name, player_name)
    |> put_session("player_name", player_name)
  end
end
