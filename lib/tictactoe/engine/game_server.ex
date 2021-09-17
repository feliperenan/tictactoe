defmodule Tictactoe.Engine.GameServer do
  @moduledoc """
  Create a process for a game with two players.

  Only two players can join into a GameServer once one was created by `start_link/1`. Use `join_player/2`
  for joining users and `put_player_symbol/3` to add the player's symbol in some board position. For
  leaving the game, use `leave/2`.
  """

  alias Tictactoe.Engine.{Board, Game, GameListRegistry}

  use GenServer

  ## Client

  @doc """
  Starts a game process with the given name.

  It uses `via_tuple/1` to registry this process and its PID in the Registry.
  """
  def start_link(name, initial_state \\ %Game{}) do
    game = %{initial_state | name: name}

    GenServer.start_link(__MODULE__, game, name: via_tuple(name))
  end

  @doc """
  Joins the given player in the given game.

  The first player always is going to be the symbol :x and the second one the symbol :o. An error
  will be returned case a third player tries to join in a game that already has two players.
  """
  def join_player(game, player) do
    game
    |> via_tuple
    |> GenServer.call({:join_player, player})
  end

  @doc """
  Put on the board the players' symbol given the position.

  There are some checks before and after the players' symbol is put on the board, as follow:

  ## Before
  - Case the game is finished it will return an error.
  - Case it's not the player's turn it will return an error.

  ## After
  - Case there is a winner it will finish the game and add the winner symbol to the game state.
  - Case the board is fulfilled it will finish the game.
  - Case there is no winner and the board is not fullfilled it will only change which player is the
    next.

  """
  def put_player_symbol(game, symbol, position) do
    game
    |> via_tuple
    |> GenServer.call({:put_player_symbol, symbol, position})
  end

  @doc """
  Reset the game state and change which player is the first allowing players to play the game again.
  """
  def new_round(game) do
    game
    |> via_tuple
    |> GenServer.call(:new_round)
  end

  @doc """
  Remove the given player's symbol from the game state.

  Case the given symbol is the last player in the given game, the game's process is going to die.
  """
  def leave(game, symbol) do
    game
    |> via_tuple
    |> GenServer.call({:leave, symbol})
  end

  # Uses Registry to register the game in the state.
  #
  # via tuple is a way to tell Elixir that we'll use a custom module to register our processes. In
  # this case, I'm using Registry to do this work.
  defp via_tuple(name) do
    {:via, Registry, {:game_server_registry, name}}
  end

  ## Server callbacks

  @impl true
  def init(game \\ %Game{}) do
    GameListRegistry.register(game.name)

    {:ok, game}
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
    {:reply, {:error, "this game is already finished"}, state}
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
    {:reply, {:error, "It's not :#{symbol} turn. Now it's :#{next} turn"}, state}
  end

  @impl true
  def handle_call(:new_round, _from, %Game{} = state) do
    new_state =
      state
      |> Game.reset_board()
      |> Game.change_first()

    {:reply, {:ok, new_state}, new_state}
  end

  @impl true
  def handle_call({:leave, symbol}, _from, state) do
    new_state =
      state
      |> Game.remove_player(symbol)
      |> Game.reset_board()

    if Game.without_players?(new_state) do
      {:stop, :normal, {:closed, new_state}, new_state}
    else
      {:reply, {:ok, new_state}, new_state}
    end
  end
end
