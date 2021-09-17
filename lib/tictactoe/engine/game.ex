defmodule Tictactoe.Engine.Game do
  @moduledoc """
  Struct and functions to control a game state.
  """

  alias Tictactoe.Engine.Board

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

      iex> Game.finish(%Game{finished: false}, :x)
      %Game{finished: true, winner: :x}

  """
  def finish(%__MODULE__{} = game, winner) do
    %__MODULE__{game | finished: true, winner: winner}
  end

  @doc """
  Changes who player is the next.

  * Case the actual is :x, it is going to change to :o be the next.
  * Case the actual is :o, it is going to change to :x be the next.

  ## Examples

      iex> Game.next_turn(%Game{next: :x})
      %Game{next: :o}

      iex> Game.next_turn(%Game{next: :o})
      %Game{next: :x}

  """
  def next_turn(%__MODULE__{next: :x} = game), do: %__MODULE__{game | next: :o}
  def next_turn(%__MODULE__{next: :o} = game), do: %__MODULE__{game | next: :x}

  @doc """
  Changes which player will be the starter.

  * Case the actual is :x, it is going to change to :o be the next.
  * Case the actual is :o, it is going to change to :x be the next.

  ## Examples

      iex> Game.change_first(%Game{first: :x})
      %Game{first: :o, next: :o}

      iex> Game.change_first(%Game{first: :o})
      %Game{first: :x, next: :x}

  """
  def change_first(%__MODULE__{first: :x} = game), do: %__MODULE__{game | first: :o, next: :o}
  def change_first(%__MODULE__{first: :o} = game), do: %__MODULE__{game | first: :x, next: :x}

  @doc """
  Removes the given player from the Game.

  ## Examples

      iex> Game.remove_player(%Game{x: "player_1", o: "player_2"}, :x)
      %Game{x: nil, o: "player_2"}

  """
  def remove_player(%__MODULE__{} = game, player_symbol),
    do: %{game | player_symbol => nil}

  @doc """
  Resets the board states and changes the Game to unfinished.

  ## Examples

      iex> board = %Board{positions: [:x, :x, nil, :o, :o, :o, nil, :x, nil]}
      iex> Game.reset_board(%Game{board: board, finished: true})
      %Game{board: %Board{}, finished: false}

  """
  def reset_board(%__MODULE__{} = game) do
    %__MODULE__{game | board: %Board{}, finished: false}
  end

  @doc """
  Checks if the game is without players.

  ## Examples

      iex> Game.without_players?(%Game{x: nil, o: nil})
      true

      iex> Game.without_players?(%Game{x: "player_1", o: "player_2"})
      false

      iex> Game.without_players?(%Game{x: "player_1", o: nil})
      false

      iex> Game.without_players?(%Game{x: nil, o: "player_2"})
      false

  """
  def without_players?(%__MODULE__{x: nil, o: nil}), do: true
  def without_players?(%__MODULE__{x: _, o: _}), do: false
end
