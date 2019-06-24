defmodule GameEngine do
  @moduledoc """
  Expose all public API's for projects that depend on `GameEngine`.
  """

  alias GameEngine.{GameServer, GameSupervisor, PubSub}

  defdelegate join_player(game, player), to: GameServer
  defdelegate put_player_symbol(game, symbol, pos), to: GameServer
  defdelegate new_round(game), to: GameServer
  defdelegate leave(game, symbol), to: GameServer

  @doc """
  Finds or create a `GameServer` process under `GameSupervisor`.
  """
  def find_or_create_game(game_name) do
    if GameSupervisor.game_exists?(game_name) do
      game_name
    else
      {:ok, _pid} = GameSupervisor.create_game(game_name)
      game_name
    end
  end

  @doc """
  Subscribe to the given event_types.

  Check `PubSub.subscribe/1` to see the event types supported.

  ### Examples

    iex> GameEngine.subscribe([:game_created, :game_closed])
    :ok

  """
  def subscribe(event_types) do
    for event_type <- event_types, do: PubSub.subscribe(event_type)
  end
end
