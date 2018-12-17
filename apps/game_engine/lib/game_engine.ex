defmodule GameEngine do
  alias GameEngine.{GameRegistry, GameServer, GameSupervisor}

  defdelegate join_player(game, player), to: GameServer
  defdelegate put_player_symbol(game, symbol, pos), to: GameServer
  defdelegate new_round(game), to: GameServer
  defdelegate leave(game, symbol), to: GameServer

  def find_or_create_game(game_name) do
    case GameRegistry.whereis_name(game_name) do
      :undefined ->
        {:ok, _pid} = GameSupervisor.start_child(game_name)
        game_name

      _ ->
        game_name
    end
  end
end
