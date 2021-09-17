defmodule TictactoeWeb.GameView do
  use TictactoeWeb, :view

  @doc """
  Get the user's name according to game's winner symbol.

  Returns a String.
  """
  def winner_name(game) do
    Map.get(game, game.winner)
  end
end
