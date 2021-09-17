defmodule Tictactoe.Engine.Factories.GameFactory do
  use ExZample.DSL

  alias Tictactoe.Engine.Game

  factory :game do
    example do
      %Tictactoe.Engine.Game{
        board: build(:board),
        finished: false,
        first: :x,
        next: :x,
        o: nil,
        winner: nil,
        x: nil,
        name: "new game"
      }
    end
  end
end
