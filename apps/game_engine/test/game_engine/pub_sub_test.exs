defmodule GameEngine.PubSubTest do
  use ExUnit.Case, async: true

  alias GameEngine.PubSub

  doctest PubSub

  describe "broadcast/1" do
    test "broadcast an :game_created event" do
      event_type = :game_created

      assert PubSub.broadcast(event_type) == :ok
    end

    test "broadcast an :game_closed event" do
      event_type = :game_closed

      assert PubSub.broadcast(event_type) == :ok
    end
  end

  describe "subscribe/1" do
    test "subscribe to game engine event" do
      event_type = :game_created

      PubSub.subscribe(event_type)
      PubSub.broadcast(event_type)

      assert_received {:game_engine_event, ^event_type}
    end
  end
end
