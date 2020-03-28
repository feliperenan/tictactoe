defmodule GameEngine.Factories.GameFactory do
  use ExZample.DSL

  alias GameEngine.Game

  factory :game do
    example do
      %GameEngine.Game{
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
