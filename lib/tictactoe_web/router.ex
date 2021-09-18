defmodule TictactoeWeb.Router do
  use TictactoeWeb, :router

  alias TictactoeWeb.Plugs.Session

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {TictactoeWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Session)
  end

  scope "/", TictactoeWeb do
    pipe_through(:browser)

    live("/", PlayerNewLive)
    live("/games/new", GameNewLive)
    live("games/:id/show", GameShowLive)

    delete("/logout", LogoutController, :delete)
  end
end
