defmodule GameEngine.GameTest do
  use GameEngine.DataCase

  alias GameEngine.{Game, Board}

  doctest GameEngine.Game

  describe "finish/2" do
    test "changes the given game to finished and sets the winner" do
      game = build(:game, finished: false, winner: nil)

      expected_game = Game.finish(game, :x)

      assert expected_game.finished == true
      assert expected_game.winner == :x
    end
  end

  describe "next_turn/1" do
    test "changes to :o turn when the current player was :x" do
      game = build(:game, next: :x)

      expected_game = Game.next_turn(game)

      assert expected_game.next == :o
    end

    test "changes to :x turn when the current player was :o" do
      game = build(:game, next: :o)

      expected_game = Game.next_turn(game)

      assert expected_game.next == :x
    end
  end

  describe "change_first/1" do
    test "changes to :o turn when the current player was :x" do
      game = build(:game, first: :x)

      expected_game = Game.change_first(game)

      assert expected_game.first == :o
      assert expected_game.next == :o
    end

    test "changes to :x turn when the current player was :o" do
      game = build(:game, first: :o)

      expected_game = Game.change_first(game)

      assert expected_game.first == :x
      assert expected_game.next == :x
    end
  end

  describe "remove_player/2" do
    test "removes the given player from the game" do
      game = build(:game)

      expected_game = Game.remove_player(game, :x)

      assert expected_game.x == nil
    end
  end

  describe "reset_board/1" do
    test "resets board states and changes the game to unfinished" do
      game = build(:game, board: build(:board_full_filled), finished: true)

      expected_game = Game.reset_board(game)

      assert expected_game.board == build(:board)
      assert expected_game.finished == false
    end
  end

  describe "without_players?/1" do
    test "returns true when there are no player in the game" do
      game = build(:game, x: nil, o: nil)

      assert Game.without_players?(game)
    end

    test "returns false when there at least one player in the game" do
      game = build(:game, x: "Felipe", o: nil)

      refute Game.without_players?(game)
    end
  end
end
