defmodule GameEngine.GameServer do
  @moduledoc """
  Create a process for a game with two players.

  Only two players can join into a GameServer once one was created by `start_link/1`. Use `join_player/2`
  for joining users and `put_player_symbol/3` to add the player's symbol in some board position. For
  leaving the game, use `leave/2`.

  ## Examples

  ```Elixir
  alias GameEngine.{Game, GameServer, Board}

  # Start a game sever.
  {:ok, game_pid} = GameServer.start_link("new_game")

  # Join Player 1.
  {:ok, player1_symbol, game} = GameServer.join_player("new_game", "player_1")

  # Join Player 2.
  {:ok, player2_symbol, game} = GameServer.join_player("new_game", "player_2")

  # Put player 1 symbol (:x) into the position 1 of the board.
  GameServer.put_player_symbol("new_game", player1_symbol, 1)

  # Put player 2 symbol (:o) into the position 1 of the board.
  GameServer.put_player_symbol("new_game", player2_symbol, 0)
  ```
  """

  alias GameEngine.{Board, Game, GameRegistry}

  use GenServer

  ## Client

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(name))
  end

  def join_player(game, player) do
    GenServer.call(via_tuple(game), {:join_player, player})
  end

  def put_player_symbol(game, symbol, pos) do
    GenServer.call(via_tuple(game), {:put_player_symbol, symbol, pos})
  end

  def new_round(game) do
    GenServer.call(via_tuple(game), :new_round)
  end

  def leave(game, symbol) do
    GenServer.cast(via_tuple(game), {:leave, symbol})
  end

  defp via_tuple(name) do
    {:via, GameRegistry, name}
  end

  ## Server callbacks

  @impl true
  def init(_) do
    {:ok, %Game{}}
  end

  @impl true
  def handle_call({:join_player, player}, _from, %{x: nil} = state) do
    new_state = %{state | x: player}

    {:reply, {:ok, :x, new_state}, new_state}
  end

  @impl true
  def handle_call({:join_player, player}, _from, %{o: nil} = state) do
    new_state = %{state | o: player}

    {:reply, {:ok, :o, new_state}, new_state}
  end

  @impl true
  def handle_call({:join_player, _player}, _from, state) do
    {:reply, {:error, "This game already has two players"}, state}
  end

  @impl true
  def handle_call({:put_player_symbol, _symbol, _pos}, _from, %Game{finished: true} = state) do
    {:reply, :finished, state}
  end

  @impl true
  def handle_call({:put_player_symbol, symbol, position}, _from, %Game{next: symbol} = state) do
    case Board.put(state.board, position, symbol) do
      {:error, error_message} ->
        {:reply, {:retry, error_message}, state}

      board ->
        state = %{state | board: board}

        cond do
          winner = Board.winner(board) ->
            new_state = Game.finish(state, winner)
            {:reply, {:winner, new_state}, new_state}

          Board.full?(board) ->
            new_state = Game.finish(state, :draw)
            {:reply, {:draw, new_state}, new_state}

          true ->
            new_state = Game.next_turn(state)
            {:reply, {:ok, new_state}, new_state}
        end
    end
  end

  @impl true
  def handle_call({:put_player_symbol, symbol, _position}, _from, %Game{next: next} = state) do
    {:reply, "It's not :#{symbol} turn. Now it's :#{next} turn", state}
  end

  @impl true
  def handle_call(:new_round, _from, %Game{} = state) do
    new_state =
      state
      |> Game.reset_board()
      |> Game.change_first()

    {:reply, new_state, new_state}
  end

  @impl true
  def handle_cast({:leave, symbol}, state) do
    new_state =
      state
      |> Game.remove_player(symbol)
      |> Game.reset_board()

    if Game.without_players?(new_state) do
      {:stop, :normal, new_state}
    else
      {:noreply, new_state}
    end
  end
end
