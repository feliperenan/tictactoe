defmodule GameUiWeb.GameChannel do
  @channel_prefix "game:"

  def subscribe(name) do
    Phoenix.PubSub.subscribe(GameUi.PubSub, @channel_prefix <> name)
  end

  def broadcast!(name, event, assigns) do
    GameUiWeb.Endpoint.broadcast!(@channel_prefix <> name, event, assigns)
  end
end
