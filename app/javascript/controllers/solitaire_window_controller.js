import { Controller } from "@hotwired/stimulus"

// The floating Solitaire window the easter egg opens. It's a non-modal
// <dialog> marked data-turbo-permanent, so it and the game in it ride along
// as you navigate the site. Opening deals the board in from the template;
// closing (× or File > Quit) throws it away, so the next open is a new game.
// The title bar drags it around, and CSS resize lets the corner grip size it.
export default class extends Controller {
  static targets = ["body", "template"]

  #drag = null

  open() {
    if (!this.element.open) {
      this.bodyTarget.replaceChildren(this.templateTarget.content.cloneNode(true))
      this.element.show()
    }
  }

  discard() {
    this.bodyTarget.replaceChildren()
  }

  grab(event) {
    if (event.target.closest("button") || event.button !== 0) return

    const { offsetLeft, offsetTop } = this.element
    this.#drag = { x: event.clientX - offsetLeft, y: event.clientY - offsetTop }
    event.currentTarget.setPointerCapture(event.pointerId)
  }

  // The title bar can't be dragged off the top of the screen, and enough of
  // it stays on screen elsewhere to grab it back.
  drag({ clientX, clientY, currentTarget: titlebar }) {
    if (!this.#drag) return

    const grip = 48
    const left = clamp(clientX - this.#drag.x, grip - this.element.offsetWidth, window.innerWidth - grip)
    const top = clamp(clientY - this.#drag.y, 0, window.innerHeight - titlebar.offsetHeight)
    this.element.style.left = `${left}px`
    this.element.style.top = `${top}px`
  }

  drop() {
    this.#drag = null
  }
}

function clamp(value, min, max) {
  return Math.min(Math.max(value, min), max)
}
