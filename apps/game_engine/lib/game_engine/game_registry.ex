defmodule GameEngine.GameRegistry do
  @moduledoc """
  This module is responsible for managing the `GameEngine.GameServer` name as via_tuple.

  Via tuple is basically a way to tell Elixir that we are going to use a custom module to register
  our processes. This way, we can create a whatever `GameEngine.GameServer` we want once they have
  a unique name.

  This code is based on this beautiful blog post:
  https://m.alphasights.com/process-registry-in-elixir-a-practical-example-4500ee7c0dcc

  I could use the erlang library `:gproc`, but for this project I rather this code to understand
  better what's going on.
  """

  use GenServer

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def whereis_name(game_name) do
    GenServer.call(__MODULE__, {:whereis_name, game_name})
  end

  def register_name(game_name, pid) do
    GenServer.call(__MODULE__, {:register_name, game_name, pid})
  end

  def unregister_name(game_name) do
    GenServer.cast(__MODULE__, {:unregister_name, game_name})
  end

  def send(game_name, message) do
    case whereis_name(game_name) do
      :undefined ->
        {:badarg, {game_name, message}}

      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  # Server

  @impl true
  def init(_) do
    {:ok, Map.new()}
  end

  @impl true
  def handle_call({:whereis_name, game_name}, _from, state) do
    game_pid = Map.get(state, game_name, :undefined)

    {:reply, game_pid, state}
  end

  @impl true
  def handle_call({:register_name, game_name, pid}, _from, state) do
    case Map.get(state, game_name) do
      nil ->
        # Start monitoring this pid then handle_info/2 removes it from the state case this proccess
        # dies.
        Process.monitor(pid)
        {:reply, :yes, Map.put(state, game_name, pid)}

      _ ->
        {:reply, :no, state}
    end
  end

  @impl true
  def handle_cast({:unregister_name, game_name}, state) do
    new_state = Map.delete(state, game_name)

    {:noreply, new_state}
  end

  @impl true
  def handle_info({:DOWN, _, :process, pid, _}, state) do
    new_state =
      state
      |> Enum.filter(fn {_key, state_pid} -> state_pid != pid end)
      |> Enum.into(%{})

    {:noreply, new_state}
  end
end
