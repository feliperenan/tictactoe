defmodule GameEngine do
  @moduledoc """
  Expose all public API's for projects that depend on `GameEngine`.
  """

  alias GameEngine.{GameServer, GameSupervisor, GameListRegistry, PubSub}

  defdelegate join_player(game, player), to: GameServer
  defdelegate put_player_symbol(game, symbol, pos), to: GameServer
  defdelegate new_round(game), to: GameServer
  defdelegate active_games, to: GameListRegistry

  @doc """
  Find or create a `GameServer` process under `GameSupervisor`.

  ### Examples

    iex> GameEngine.find_or_create_game("my-game")
    "my-game"

  """
  def find_or_create_game(game_name) do
    if GameSupervisor.game_exists?(game_name) do
      game_name
    else
      {:ok, _pid} = GameSupervisor.create_game(game_name)

      PubSub.broadcast(:game_created)

      game_name
    end
  end

  @doc """
  Leave the given symbol from the game.

  It will broadcast the event `:game_closed` once the game process is closed when the last player
  leaves the game.

  ### Examples

    iex> Game.leave("game-1", :x)
    {:ok, %Game{...}}

  """
  def leave(game, symbol) do
    case GameServer.leave(game, symbol) do
      {:ok, game_state} ->
        {:ok, game_state}

      {:closed, game_state} ->
        PubSub.broadcast(:game_closed)
        {:ok, game_state}
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
