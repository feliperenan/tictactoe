import Board from './board'
import Players from './players'
import socket from './socket'
import { hideElement, showElement } from './utils'

class Game {
  constructor(element) {
    this.element        = element
    this.waitingEl      = this.element.querySelector('[data-waiting]')
    this.errorEl        = this.element.querySelector('[data-error]')
    this.finishedGameEl = this.element.querySelector('[data-finished-game]')
    this.newGameEl      = this.element.querySelector('[data-new-game]')

    this.playersEl = this.element.querySelector('[data-players]')
    this.boardEl   = this.element.querySelector('[data-board]')

    this.board   = new Board(this.boardEl)
    this.players = new Players(this.playersEl)
    this.name    = this.element.dataset.game

    this.channel = this._joinChannel()
  }

  init() {
    // Listen channel events
    this.channel.on('new_player', this._onNewPlayer.bind(this))
    this.channel.on('update_board', this._onUpdateBoard.bind(this))
    this.channel.on('finish_game', this._onFinishGame.bind(this))
    this.channel.on('new_round', this._onNewRound.bind(this))
    this.channel.on('player_left', this._onPlayerLeft.bind(this))

    // Listen DOM events
    this.boardEl.addEventListener('click', this._onBoardClick.bind(this))
    this.newGameEl.addEventListener('click', this._onNewGameClick.bind(this))
  }

  _onNewPlayer(response) {
    if (response.x && response.o) {
      this.board.update(response)
      this.players.update(response)
      this.players.next(response.next)

      hideElement(this.waitingEl)
      hideElement(this.finishedGameEl)
      showElement(this.boardEl)
      showElement(this.playersEl)
    } else {
      showElement(this.waitingEl)
    }
  }

  _onUpdateBoard(response) {
    this.board.update(response)
    this.players.next(response.next)
  }

  _onFinishGame(response) {
    this.board.update(response)

    let message
    if(response.winner != "draw") {
      message = `${response[response.winner]} won the game`
    } else {
      message = 'Draw game'
    }

    this.finishedGameEl.querySelector('[data-message]').innerHTML = message

    hideElement(this.playersEl)
    showElement(this.finishedGameEl)
  }

  _onNewRound(response) {
    hideElement(this.finishedGameEl)
    showElement(this.playersEl)

    this.board.update(response)
    this.players.next(response.next)
  }

  _onPlayerLeft(response) {
    hideElement(this.playersEl)
    hideElement(this.finishedGameEl)
    hideElement(this.boardEl)
    showElement(this.waitingEl)
  }

  _onBoardClick(event) {
    event.preventDefault()

    const index = event.target.getAttribute('data-index')

    if(window.currentPlayer === this.board.nextPlayer) {
      this.channel.push('put', {index})
    }
  }

  _onNewGameClick(event) {
    event.preventDefault()
    this.channel.push('new_round')
  }

  _joinChannel() {
    socket.connect()

    const channel  = socket.channel("game: " + this.name)
    channel.params.player = window.currentPlayer
    channel.join()
      .receive("ok", resp => console.log("Game channel connected"))
      .receive("error", this._onChannelError.bind(this))

    return channel
  }

  _onChannelError(response) {
    this.errorEl.innerHTML = response.reason

    showElement(this.errorEl)
  }
}

export default Game
