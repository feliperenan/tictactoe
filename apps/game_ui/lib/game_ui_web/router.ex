defmodule GameUiWeb.Router do
  use GameUiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug GameUiWeb.Plugs.Player
    plug Phoenix.LiveView.Flash
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", GameUiWeb do
    pipe_through :browser

    get "/", PlayerController, :new
    resources "/players", PlayerController, only: [:new, :create, :delete]

    resources "/games", GameController, only: [:new, :create, :show], param: "name"
  end

  # Other scopes may use custom stacks.
  # scope "/api", GameUiWeb do
  #   pipe_through :api
  # end
end
