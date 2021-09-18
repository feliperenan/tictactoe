defmodule TictactoeWeb.NewGameComponent do
  use TictactoeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div
      class="
        min-w-screen
        h-screen
        animated
        fadeIn
        faster
        fixed
        left-0
        top-0
        flex
        justify-center
        items-center
        inset-0
        z-50
        outline-none
        focus:outline-none
        bg-no-repeat
        bg-center
        bg-cover">
      <div class="absolute bg-black opacity-80 inset-0 z-0"></div>
        <div class="w-full max-w-lg p-5 relative mx-auto my-auto rounded-xl shadow-lg bg-white">
          <div class="text-center p-5 flex-auto justify-center">
          <%= if @game.winner == :draw do %>
            <h2 class="text-xl font-bold py-4 ">DRAW Game</h2>
          <% else %>
            <h2><%= Map.get(@game, @game.winner) <> " WON this Game" %></h2>
          <% end %>
          </div>
          <div class="p-3  mt-2 text-center space-x-4 d:block">
          <button
            phx-click="new_round"
            class="
              mb-2
              md:mb-0
              bg-white
              px-5 py-2
              text-sm
              shadow-sm
              font-medium
              tracking-wider
              border
              text-gray-600
              rounded-full
              hover:shadow-lg
              hover:bg-gray-100">
                New Game
          </button>
        </div>
      </div>
    </div>
    """
  end
end
