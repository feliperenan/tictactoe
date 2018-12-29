import { hideElement, showElement } from './utils'

class Players {
  constructor(element) {
    this.element = element
    this.playerX = element.querySelector('[data-player-x]')
    this.playerO = element.querySelector('[data-player-o]')
    this.playerXname = this.playerX.querySelector('[data-player-x-name]')
    this.playerOname = this.playerO.querySelector('[data-player-o-name]')
    this.playerXturn = this.playerX.querySelector('[data-player-x-turn]')
    this.playerOturn = this.playerO.querySelector('[data-player-o-turn]')
  }

  update(game) {
    this.playerXname.innerHTML = game.x
    this.playerOname.innerHTML = game.o
  }

  next(next) {
    if (next == "x") {
      hideElement(this.playerOturn)
      showElement(this.playerXturn)

      this.playerX.classList.add("player-active")
      this.playerO.classList.remove("player-active")
    } else {
      hideElement(this.playerXturn)
      showElement(this.playerOturn)

      this.playerX.classList.remove("player-active")
      this.playerO.classList.add("player-active")
    }
  }
}

export default Players
