defmodule GameEngine.GameSupervisor do
  alias GameEngine.GameServer

  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Creates a game server given the name under this dynamic supervisor.

  As the `GameServer` stops when there are no players in the process anymore, we don't want that
  this Supervisor starts it after this process is finished. Because that the process is started
  using `restart: :temporary`.
  """
  def create_game(name) do
    child_spec = %{
      id: GameServer,
      start: {GameServer, :start_link, [name]},
      restart: :temporary
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  Checks if there is a `GameServer` process running with the given name.
  """
  def game_exists?(game_name) do
    case Registry.lookup(:game_server_registry, game_name) do
      [] -> false
      _ -> true
    end
  end
end
