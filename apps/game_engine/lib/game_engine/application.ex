defmodule GameEngine.Application do
  alias GameEngine.{GameRegistry, GameSupervisor}

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      GameRegistry,
      GameSupervisor
    ]

    opts = [strategy: :one_for_one, name: GameEngine.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
