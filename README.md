# TIC TAC TOE
This game is implemented in Elixir. The code is based on this [talk](https://speakerdeck.com/ventsislaf/building-multiplayer-real-time-game-with-elixir-and-phoenix). 

![Game example](gifs/game_example.gif)

This game is deployed on GigaElixir in case you want to check this out: https://frg-tictactoe.gigalixirapp.com/

## Setup

```bash
$ git clone git@github.com:feliperenan/tictactoe.git
$ cd tictactoe
$ mix deps.get
$ cd assets && npm install
$ cd .. && mix phx.server
```

Go to localhost:4000 and the game is going to be ready to play.
