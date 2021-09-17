defmodule Tictactoe.Engine.PubSub do
  @moduledoc """
  Provide functions to broadcast and subscribe events to listen in other process.
  """

  @event_types ~w(game_created game_closed)a
  @registry_name Registry.Tictactoe.EngineEvents

  @doc """
  Broadcast the given event type to all subscribers.

  ## Examples

    iex> Tictactoe.Engine.PubSub.broadcast(:game_created)
    :ok
  """
  def broadcast(event_type) when event_type in @event_types do
    Registry.dispatch(@registry_name, event_type, &dispatch_for_subscribers(&1, event_type))
  end

  defp dispatch_for_subscribers(entries, event_type) do
    for {pid, _registered_val} <- entries, do: send(pid, {:game_engine_event, event_type})
  end

  @doc """
  Subscribe to the given event type.

  Once a process has subscribed, make sure to implement callbacks to `{:game_engine_event, event_type}` message.

  ## Examples

    iex> Tictactoe.Engine.PubSub.subscribe(:game_created)
    :ok
  """
  def subscribe(event_type) when event_type in @event_types do
    {:ok, _pid} = Registry.register(@registry_name, event_type, [])
    :ok
  end
end
