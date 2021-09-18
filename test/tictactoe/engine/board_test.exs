defmodule Tictactoe.Engine.BoardTest do
  use Tictactoe.Engine.DataCase

  alias Tictactoe.Engine.Board

  doctest Board

  describe "put/3" do
    test "put the given symbol in the given position" do
      board = build(:board)

      expected_board =
        board
        |> Board.put(3, :x)
        |> Board.put(1, :o)

      assert expected_board.positions == [nil, :o, nil, :x, nil, nil, nil, nil, nil]
    end

    test "doesn't allow any other symbol than :x or :o" do
      board = build(:board)

      expected_board = Board.put(board, 3, :a)

      assert expected_board ==
               {:error,
                "Wrong symbol and/or wrong position. Check if you are passing :x or :o as symbol and a position between 0 and 8."}
    end

    test "returns error when a wrong position is given" do
      board = build(:board)

      expected_board = Board.put(board, 10, :x)

      assert expected_board ==
               {:error,
                "Wrong symbol and/or wrong position. Check if you are passing :x or :o as symbol and a position between 0 and 8."}
    end

    test "returns an error when the given position already has a symbol" do
      board = build(:board)

      expected_board =
        board
        |> Board.put(1, :x)
        |> Board.put(1, :o)

      assert expected_board == {:error, "The position: 1 already has the symbol: x"}
    end
  end

  describe "full?/1" do
    test "returns false when it still has positions without symbol" do
      board =
        :board
        |> build()
        |> Board.put(1, :x)
        |> Board.put(8, :o)

      refute Board.full?(board)
    end

    test "returns true when it's full filled" do
      board = build(:board_full_filled)

      assert Board.full?(board)
    end
  end

  describe "winner/1" do
    test "returns the winner symbol when he/she completes the first row" do
      board = build(:board, positions: [:x, :x, :x, :o, :o, nil, nil, nil, nil])

      assert Board.winner(board) == :x
    end

    test "returns the winner symbol when he/she completes the second row" do
      board = build(:board, positions: [nil, :x, :x, :o, :o, :o, nil, nil, nil])

      assert Board.winner(board) == :o
    end

    test "returns the winner symbol when he/she completes the third row" do
      board = build(:board, positions: [nil, :x, :x, :o, :o, :x, :o, :o, :o])

      assert Board.winner(board) == :o
    end

    test "returns the winner symbol when he/she completes the first column" do
      board = build(:board, positions: [:x, :o, :o, :x, :x, :o, :x, nil, nil])

      assert Board.winner(board) == :x
    end

    test "returns the winner symbol when he/she completes the second column" do
      board = build(:board, positions: [:x, :o, :o, :o, :o, :x, :x, :o, nil])

      assert Board.winner(board) == :o
    end

    test "returns the winner symbol when he/she completes the third column" do
      board = build(:board, positions: [:x, :o, :x, :o, :x, :x, :o, :x, :x])

      assert Board.winner(board) == :x
    end

    test "returns the winner symbol when he/she completes diagonal right" do
      board = build(:board, positions: [:o, :x, :x, :x, :o, nil, nil, :x, :o])

      assert Board.winner(board) == :o
    end

    test "returns the winner symbol when he/she completes diagonal left " do
      board = build(:board, positions: [nil, :x, :o, :x, :o, nil, :o, :x, nil])

      assert Board.winner(board) == :o
    end
  end
end
