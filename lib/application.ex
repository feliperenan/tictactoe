defmodule Tictactoe.Application do
  alias Tictactoe.Engine.GameSupervisor

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      {Registry, keys: :unique, name: :game_server_registry},
      {Registry, keys: :duplicate, name: Registry.Tictactoe.EngineEvents},
      {Registry, keys: :duplicate, name: Registry.GameList},
      {Phoenix.PubSub, name: Tictactoe.PubSub},
      TictactoeWeb.Endpoint,
      GameSupervisor
    ]

    TictactoeWeb.PlayerETS.new()

    opts = [strategy: :one_for_one, name: Tictactoe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TictactoeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
