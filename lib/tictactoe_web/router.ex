defmodule TictactoeWeb.Router do
  use TictactoeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :put_root_layout, {TictactoeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TictactoeWeb.Plugs.Player
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", TictactoeWeb do
    pipe_through :browser

    get "/", PlayerController, :new
    resources "/players", PlayerController, only: [:new, :create, :delete]

    resources "/games", GameController, only: [:new, :create, :show], param: "name"
  end

  # Other scopes may use custom stacks.
  # scope "/api", TictactoeWeb do
  #   pipe_through :api
  # end
end
