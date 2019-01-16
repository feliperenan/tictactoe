defmodule GameEngine.GameSupervisor do
  alias GameEngine.GameServer

  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_game(name) do
    # restart: :temporary because the GameServer stops when there are no players anymore and we
    # don't want to restart the server.
    child_spec = %{
      id: GameServer,
      start: {GameServer, :start_link, [name]},
      restart: :temporary
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def game_exists?(game_name) do
    case Registry.lookup(:game_server_registry, game_name) do
      [] -> false
      _ -> true
    end
  end
end
