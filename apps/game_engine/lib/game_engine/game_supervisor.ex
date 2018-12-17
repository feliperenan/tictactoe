defmodule GameEngine.GameSupervisor do
  alias GameEngine.GameServer

  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_child(name) do
    # restart: :temporary because the GameServer stops when there are no players anymore and we 
    # don't want to restart the server.
    child_spec = %{
      id: GameServer,
      start: {GameServer, :start_link, [name]},
      restart: :temporary
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
