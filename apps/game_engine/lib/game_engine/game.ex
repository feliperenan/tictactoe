defmodule GameEngine.Game do
  @moduledoc """
  Struct and functions to control a game state.
  """

  alias GameEngine.Board

  defstruct board: %Board{},
            x: nil,
            o: nil,
            next: :x,
            first: :x,
            finished: false,
            winner: nil,
            name: nil

  @doc """
  Changes the given game to finished.

  ## Examples

      iex> GameEngine.Game.finish(%GameEngine.Game{finished: false}, :x)
      %GameEngine.Game{finished: true, winner: :x}

  """
  def finish(%__MODULE__{} = game, winner) do
    %__MODULE__{game | finished: true, winner: winner}
  end

  @doc """
  Changes who player is the next.

  * Case the actual is :x, it is going to change to :o be the next.
  * Case the actual is :o, it is going to change to :x be the next.

  ## Examples

      iex> GameEngine.Game.next_turn(%GameEngine.Game{next: :x})
      %GameEngine.Game{next: :o}

      iex> GameEngine.Game.next_turn(%GameEngine.Game{next: :o})
      %GameEngine.Game{next: :x}

  """
  def next_turn(%__MODULE__{next: :x} = game), do: %__MODULE__{game | next: :o}
  def next_turn(%__MODULE__{next: :o} = game), do: %__MODULE__{game | next: :x}

  @doc """
  Changes which player will be the starter.

  * Case the actual is :x, it is going to change to :o be the next.
  * Case the actual is :o, it is going to change to :x be the next.

  ## Examples

      iex> GameEngine.Game.change_first(%GameEngine.Game{first: :x})
      %GameEngine.Game{first: :o, next: :o}

      iex> GameEngine.Game.change_first(%GameEngine.Game{first: :o})
      %GameEngine.Game{first: :x, next: :x}

  """
  def change_first(%__MODULE__{first: :x} = game), do: %__MODULE__{game | first: :o, next: :o}
  def change_first(%__MODULE__{first: :o} = game), do: %__MODULE__{game | first: :x, next: :x}

  @doc """
  Removes the given player from the Game.

  ## Examples

      iex> GameEngine.Game.remove_player(%GameEngine.Game{x: "player_1", o: "player_2"}, :x)
      %GameEngine.Game{x: nil, o: "player_2"}

  """
  def remove_player(%__MODULE__{} = game, player_symbol) do
    Map.put(game, player_symbol, nil)
  end

  @doc """
  Resets the board states and changes the Game to unfinished.

  ## Examples

      iex> board = %GameEngine.Board{positions: [:x, :x, nil, :o, :o, :o, nil, :x, nil]}
      iex> GameEngine.Game.reset_board(%GameEngine.Game{board: board, finished: true})
      %GameEngine.Game{board: %GameEngine.Board{}, finished: false}

  """
  def reset_board(%__MODULE__{} = game) do
    %__MODULE__{game | board: %Board{}, finished: false}
  end

  @doc """
  Checks if the game is without players.

  ## Examples

      iex> GameEngine.Game.without_players?(%GameEngine.Game{x: nil, o: nil})
      true

      iex> GameEngine.Game.without_players?(%GameEngine.Game{x: "player_1", o: "player_2"})
      false

      iex> GameEngine.Game.without_players?(%GameEngine.Game{x: "player_1", o: nil})
      false

      iex> GameEngine.Game.without_players?(%GameEngine.Game{x: nil, o: "player_2"})
      false

  """
  def without_players?(%__MODULE__{x: nil, o: nil}), do: true
  def without_players?(%__MODULE__{x: _, o: _}), do: false
end
