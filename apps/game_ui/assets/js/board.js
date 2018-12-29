import { isMobileDevice } from './utils'

class Board {
  constructor(element) {
    this.element = element
    this.playerX = null
    this.playerO = null
    this.next    = null

    if (isMobileDevice()) return

    this.element.addEventListener('mouseover', this._onMouseOver.bind(this))
    this.element.addEventListener('mouseout', this._onMouseLeave.bind(this))
  }

  update(game) {
    this.playerX = game.x
    this.playerO = game.o
    this.next    = game[game.next]

    const positions = game.board.positions

    for (let i = 0; i < positions.length; i++) {
      const symbol = positions[i]
      const element = this.element.querySelector("#index_" + i)

      element.innerText = symbol

      if (symbol) {
        element.classList.add(`${symbol}-mark`)
      } else {
        element.classList.remove(`o-mark`)
        element.classList.remove(`x-mark`)
      }
    }
  }

  get nextPlayer() {
    return this.next
  }

  _onMouseOver(event) {
    const element = event.target

    if(element == this.element) return
    if(this.isMarked(element)) return

    if(window.currentPlayer === this.playerX) {
      element.innerText = "x"
    } else {
      element.innerText = "o"
    }
  }

  _onMouseLeave(event) {
    const element = event.target

    if(element == this.element) return
    if(this.isMarked(element)) return

    element.innerText = ""
  }

  isMarked(element) {
    return !!element.classList.value.match(/x-mark|o-mark/)
  }
}

export default Board
