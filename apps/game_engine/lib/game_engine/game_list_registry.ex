defmodule GameEngine.GameListRegistry do
  @moduledoc """
  Module responsible to control the active games.

  Once the `game_name` is a process' name, we can use `Registry` to track this process state and
  then list the active games.
  """

  @registry_name Registry.GameList

  @doc """
  Register a game process given its name.
  """
  def register(game_name) do
    Registry.register(@registry_name, :active_games, game_name)
  end

  @doc """
  Return a list with the active games.
  """
  def active_games do
    @registry_name
    |> Registry.lookup(:active_games)
    |> Enum.map(fn {_, name} -> name end)
  end
end
