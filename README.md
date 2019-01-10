# TIC TAC TOE
This game is implemented in Elixir. The code is based on this [talk](https://speakerdeck.com/ventsislaf/building-multiplayer-real-time-game-with-elixir-and-phoenix) and I used this [board style](https://codepen.io/ziga-miklic/pen/Fagmh) as inspiration.

## How this game works?

First, the user must log in with his name and a name for the game.

![](https://github.com/feliperenan/tictactoe/blob/master/screenshots/1-log-in.png)

![](https://github.com/feliperenan/tictactoe/blob/master/screenshots/2-game-name.png)

After the user created the game, he/she will be waiting for another player.

![](https://github.com/feliperenan/tictactoe/blob/master/screenshots/3-waiting-player.png)

Once another user does the same step choosing the same game name, he/she is going to get in the game created above. Therefore, players are going to be ready to play.
![](https://github.com/feliperenan/tictactoe/blob/master/screenshots/4-board.png)

In the end, players can restart the game if they want to.

![](https://github.com/feliperenan/tictactoe/blob/master/screenshots/5-end-game.png)

## Requirements
- Elixir 1.7+
- Phoenix 1.4+

## Setup
```bash
$ git clone git@github.com:feliperenan/tictactoe.git
$ cd tictactoe
$ mix deps.get
$ mix phx.server
```

Go to localhost:4000 and the game is going to be ready to play.
