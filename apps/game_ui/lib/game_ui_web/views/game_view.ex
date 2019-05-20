defmodule GameUiWeb.GameView do
  use GameUiWeb, :view

  @doc """
  Split board positions into rows according to the given rows_number.

  Examples:

    iex> board = %{positions: [:x, :o, :x, nil, :o, :x, nil, :x, :o]}
    iex> GameUiWeb.GameView.split_in_rows_with_index(%{board: board}, 3)
    [
      [{:x, 0}, {:o, 1}, {:x, 2}],
      [{nil, 3}, {:o, 4}, {:x, 5}],
      [{nil, 6}, {:x, 7}, {:o, 8}]
    ]

  Returns a List.
  """
  def split_in_rows_with_index(%{board: board}, rows_number) do
    board.positions
    |> Enum.with_index()
    |> Enum.chunk_every(rows_number)
  end
end
