defmodule Tictactoe.Engine.Factories.BoardFactory do
  use ExZample.DSL

  alias Tictactoe.Engine.Board

  factory :board do
    example do
      %Board{}
    end
  end

  factory :board_full_filled do
    example do
      %Board{
        positions: [:x, :x, :o, :o, :x, :o, :x, :o, :x]
      }
    end
  end
end
