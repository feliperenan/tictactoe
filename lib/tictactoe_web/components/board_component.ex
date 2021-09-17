defmodule TictactoeWeb.BoardComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="grid grid-cols-3 gap-2 p-5">
      <%= for positions <- split_in_rows_with_index(@game, 3) do %>
        <%= for {symbol, index} <- positions do %>
          <%= if player_turn?(@game, @player) do %>
            <div class="<%= row_style(symbol) %>" phx-click="put_symbol" phx-value-index="<%= index %>">
              <span class="mb-5"><%= symbol %></span>
            </div>
          <% else %>
            <div class="<%= row_style(symbol) %>">
              <span class="mb-5"><%= symbol %></span>
            </div>
          <% end %>
        <% end %>
      <% end %>
    </div>
    """
  end

  # Split board positions into rows according to the given rows_number.
  #
  # Examples:
  #
  #   iex> board = %{positions: [:x, :o, :x, nil, :o, :x, nil, :x, :o]}
  #   iex> TictactoeWeb.GameView.split_in_rows_with_index(%{board: board}, 3)
  #   [
  #     [{:x, 0}, {:o, 1}, {:x, 2}],
  #     [{nil, 3}, {:o, 4}, {:x, 5}],
  #     [{nil, 6}, {:x, 7}, {:o, 8}]
  #   ]
  #
  # Returns a List.
  defp split_in_rows_with_index(%{board: board}, rows_number) do
    board.positions
    |> Enum.with_index()
    |> Enum.chunk_every(rows_number)
  end

  # Checks whether it's a player's turn or not.
  #
  # Examples:
  #
  #   iex> TictactoeWeb.GameView.player_turn?(%{next: :x}, %{symbol: :x})
  #   true
  #
  #   iex> TictactoeWeb.GameView.player_turn?(%{next: :y}, %{symbol: :x})
  #   false
  #
  # Returns a Boolean.
  defp player_turn?(%{next: next}, %{symbol: symbol}), do: next == symbol

  defp row_style(symbol) do
    default = "hover:bg-gray-300 h-24 rounded-md flex items-center justify-center text-white text-7xl"

    additional =
      case symbol do
        nil ->
          " bg-gray-100"

        :x ->
          " bg-blue-300"

        :o ->
          " bg-yellow-300"
      end

    default <> additional
  end
end
