defmodule GameEngine.Board do
  @moduledoc """
  Represents the Game Board.

  Tic tac toe game has a board with nine positions and two players represented by symbols :x and :o.
  The first player always will be represented by :x since the second one by :o.
  """

  defstruct positions: [nil, nil, nil, nil, nil, nil, nil, nil, nil]

  @symbols [:x, :o]

  @doc """
  Put a symbol in some board postition given the symbol and position.

  As the board's positions are a list with 9 positions, it checks if the given position is one of
  these positions. Otherwise an :error will be thrown.

  It doesn't allow put a symbol in a position that already has one, if you try that, an :error will
  be thrown.

  ## Examples

      iex> Board.put(%Board{}, 0, :x)
      %Board{positions: [:x, nil, nil, nil, nil, nil, nil, nil, nil]}

      iex> Board.put(%Board{}, 8, :o)
      %Board{positions: [nil, nil, nil, nil, nil, nil, nil, nil, :o]}

      iex> Board.put(%Board{}, :unknow, 8)
      {:error, "Wrong symbol and/or wrong position. Check if you are passing :x or :o as symbol and a position between 0 and 8."}

      iex> Board.put(%Board{}, 10, :o)
      {:error, "Wrong symbol and/or wrong position. Check if you are passing :x or :o as symbol and a position between 0 and 8."}

      iex> board = %Board{positions: [:x, nil, nil, nil, nil, nil, nil, nil, nil]}
      iex> Board.put(board, 0, :o)
      {:error, "The position: 0 already has the symbol: x"}

  """
  def put(board, pos, symbol) when symbol in @symbols and pos >= 0 and pos <= 8 do
    case Enum.at(board.positions, pos) do
      nil ->
        new_positions = List.replace_at(board.positions, pos, symbol)

        %__MODULE__{board | positions: new_positions}

      existent_symbol ->
        {:error, "The position: #{pos} already has the symbol: #{existent_symbol}"}
    end
  end

  def put(_board, _position, _symbol) do
    error_message =
      "Wrong symbol and/or wrong position. Check if you are passing :x or :o as" <>
        " symbol and a position between 0 and 8."

    {:error, error_message}
  end

  @doc """
  Checks if the board is fullfilled.

  ## Examples

      iex> board = %Board{positions: [:x, :o, :x, :x, :o, :o, :x, :o, :x]}
      iex> Board.full?(board)
      true

      iex> board = %Board{positions: [nil, nil, nil, nil, nil, nil, nil, nil, nil]}
      iex> Board.full?(board)
      false

  """
  def full?(%__MODULE__{positions: positions}) do
    Enum.all?(positions, & &1)
  end

  @doc """
  Check who is the winner given the board.

  ## Examples

      iex> board = %Board{positions: [:x, :x, :x, :o, :o, :x, nil, nil, nil]}
      iex> Board.winner(board)
      :x

      iex> board = %Board{positions: [:x, :x, nil, :o, :o, :o, nil, :x, nil]}
      iex> Board.winner(board)
      :o

      iex> board = %Board{positions: [nil, nil, nil, nil, nil, nil, nil, nil, nil]}
      iex> Board.winner(board)
      nil
  """
  def winner(%__MODULE__{positions: positions}) do
    do_winner(positions)
  end

  defp do_winner([
    s, s, s,
    _, _, _,
    _, _, _
  ]) when s in @symbols, do: s

  defp do_winner([
    _, _, _,
    s, s, s,
    _, _, _
  ]) when s in @symbols, do: s

  defp do_winner([
    _, _, _,
    _, _, _,
    s, s, s
  ]) when s in @symbols, do: s

  defp do_winner([
    s, _, _,
    s, _, _,
    s, _, _
  ]) when s in @symbols, do: s

  defp do_winner([
    _, s, _,
    _, s, _,
    _, s, _
  ]) when s in @symbols, do: s

  defp do_winner([
    _, _, s,
    _, _, s,
    _, _, s
  ]) when s in @symbols, do: s

  defp do_winner([
    s, _, _,
    _, s, _,
    _, _, s
  ]) when s in @symbols, do: s

  defp do_winner([
    _, _, s,
    _, s, _,
    s, _, _
  ]) when s in @symbols, do: s

  defp do_winner(_), do: nil
end
