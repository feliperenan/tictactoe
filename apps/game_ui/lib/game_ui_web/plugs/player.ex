defmodule GameUiWeb.Plugs.Player do
  import Plug.Conn
  import Phoenix.Controller

  def init(options) do
    options
  end

  def call(conn, _options) do
    cond do
      player = conn.assigns[:current_player] ->
        assign(conn, :current_player, player)

      player = get_session(conn, :current_player) ->
        assign(conn, :current_player, player)

      true ->
        assign(conn, :current_player, nil)
    end
  end
end
