defmodule TictactoeWeb.GameChannel do
  @channel_prefix "game:"

  def subscribe(name) do
    Phoenix.PubSub.subscribe(Tictactoe.PubSub, @channel_prefix <> name)
  end

  def broadcast!(name, event, assigns) do
    TictactoeWeb.Endpoint.broadcast!(@channel_prefix <> name, event, assigns)
  end
end
