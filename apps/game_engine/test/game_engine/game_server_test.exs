defmodule GameEngine.GameServerTest do
  use ExUnit.Case

  alias GameEngine.{Board, Game, GameServer}

  doctest GameServer

  @game_name "my-game"

  describe "join_player/2" do
    setup do
      start_game_server()

      :ok
    end

    test "joins the first player as :x" do
      player = "Felipe"

      expected =
        {:ok, :x,
         %GameEngine.Game{
           board: %GameEngine.Board{
             positions: [nil, nil, nil, nil, nil, nil, nil, nil, nil]
           },
           finished: false,
           first: :x,
           next: :x,
           o: nil,
           winner: nil,
           x: "Felipe",
           name: @game_name
         }}

      assert GameServer.join_player(@game_name, player) == expected
    end

    test "joins the second player as :o" do
      player_x = "Felipe"
      player_o = "Renan"

      GameServer.join_player(@game_name, player_x)

      expected =
        {:ok, :o,
         %GameEngine.Game{
           board: %GameEngine.Board{
             positions: [nil, nil, nil, nil, nil, nil, nil, nil, nil]
           },
           finished: false,
           first: :x,
           next: :x,
           o: "Renan",
           winner: nil,
           x: "Felipe",
           name: @game_name
         }}

      assert GameServer.join_player(@game_name, player_o) == expected
    end

    test "returns an error when already there are two players" do
      player_x = "Felipe"
      player_o = "Renan"

      GameServer.join_player(@game_name, player_x)
      GameServer.join_player(@game_name, player_o)

      expected = {:error, "This game already has two players"}

      assert GameServer.join_player(@game_name, "Gomes") == expected
    end
  end

  describe "put_player_symbol/3" do
    test "returns the finished game when it's finished" do
      start_game_server(%Game{finished: true})

      {:ok, player_x, _game} = GameServer.join_player(@game_name, "Felipe")
      {:ok, _player_o, _game} = GameServer.join_player(@game_name, "Renan")

      position = 0
      expected = {:error, "this game is already finished"}

      assert GameServer.put_player_symbol(@game_name, player_x, position) == expected
    end

    test "put the player symbol when it is his/her turn" do
      start_game_server()

      {:ok, player_x, _game} = GameServer.join_player(@game_name, "Felipe")
      {:ok, _player_o, _game} = GameServer.join_player(@game_name, "Renan")

      position = 0

      expected =
        {:ok,
         %GameEngine.Game{
           board: %GameEngine.Board{
             positions: [:x, nil, nil, nil, nil, nil, nil, nil, nil]
           },
           finished: false,
           first: :x,
           next: :o,
           o: "Renan",
           winner: nil,
           x: "Felipe",
           name: @game_name
         }}

      assert GameServer.put_player_symbol(@game_name, player_x, position) == expected
    end

    test "returns an error when it's not the player turn" do
      start_game_server()

      {:ok, _player_x, _game} = GameServer.join_player(@game_name, "Felipe")
      {:ok, player_o, _game} = GameServer.join_player(@game_name, "Renan")

      position = 0

      expected = {:error, "It's not :o turn. Now it's :x turn"}

      assert GameServer.put_player_symbol(@game_name, player_o, position) == expected
    end

    test "finish the game and define the winner when there is an winner" do
      start_game_server(%Game{
        board: %Board{positions: [:x, :x, nil, nil, nil, nil, nil, nil, nil]}
      })

      {:ok, player_x, _game} = GameServer.join_player(@game_name, "Felipe")
      {:ok, _player_o, _game} = GameServer.join_player(@game_name, "Renan")

      position = 2

      expected =
        {:winner,
         %GameEngine.Game{
           board: %GameEngine.Board{
             positions: [:x, :x, :x, nil, nil, nil, nil, nil, nil]
           },
           finished: true,
           first: :x,
           next: :x,
           o: "Renan",
           winner: :x,
           x: "Felipe",
           name: @game_name
         }}

      assert GameServer.put_player_symbol(@game_name, player_x, position) == expected
    end

    test "finish the game when the board is fulfilled" do
      start_game_server(%Game{
        board: %Board{positions: [:x, :o, :x, :x, :o, :x, :o, :x, nil]},
        next: :o
      })

      {:ok, _player_x, _game} = GameServer.join_player(@game_name, "Felipe")
      {:ok, player_o, _game} = GameServer.join_player(@game_name, "Renan")

      position = 8

      expected =
        {:draw,
         %GameEngine.Game{
           board: %GameEngine.Board{
             positions: [:x, :o, :x, :x, :o, :x, :o, :x, :o]
           },
           finished: true,
           first: :x,
           next: :o,
           o: "Renan",
           winner: :draw,
           x: "Felipe",
           name: @game_name
         }}

      assert GameServer.put_player_symbol(@game_name, player_o, position) == expected
    end
  end

  describe "new_round/1" do
    test "reset the board and change which player is the first" do
      start_game_server(%Game{
        board: %Board{positions: [:x, :o, :x, :x, :o, :x, :o, :x, nil]},
        finished: true,
        first: :x
      })

      {:ok, _player_x, _game} = GameServer.join_player(@game_name, "Felipe")
      {:ok, _player_o, _game} = GameServer.join_player(@game_name, "Renan")

      expected =
        {:ok,
         %GameEngine.Game{
           board: %GameEngine.Board{
             positions: [nil, nil, nil, nil, nil, nil, nil, nil, nil]
           },
           finished: false,
           first: :o,
           next: :o,
           o: "Renan",
           winner: nil,
           x: "Felipe",
           name: @game_name
         }}

      assert GameServer.new_round(@game_name) == expected
    end
  end

  describe "leave/2" do
    test "remove the player from the game server" do
      pid = start_game_server()

      {:ok, player_x, _game} = GameServer.join_player(@game_name, "Felipe")
      {:ok, _player_o, _game} = GameServer.join_player(@game_name, "Renan")

      expected =
        {:ok,
         %GameEngine.Game{
           board: %GameEngine.Board{
             positions: [nil, nil, nil, nil, nil, nil, nil, nil, nil]
           },
           finished: false,
           first: :x,
           next: :x,
           o: "Renan",
           winner: nil,
           x: nil,
           name: @game_name
         }}

      assert GameServer.leave(@game_name, player_x) == expected
      assert Process.alive?(pid)
    end

    test "stops the server when there are no players in the game" do
      pid = start_game_server()

      {:ok, player_x, _game} = GameServer.join_player(@game_name, "Felipe")
      {:ok, player_o, _game} = GameServer.join_player(@game_name, "Renan")

      GameServer.leave(@game_name, player_x)
      GameServer.leave(@game_name, player_o)

      refute Process.alive?(pid)
    end
  end

  defp start_game_server(game \\ %Game{}) do
    child_spec = %{
      id: GameServer,
      start: {GameServer, :start_link, [@game_name, game]}
    }

    start_supervised!(child_spec)
  end
end
