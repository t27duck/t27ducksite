import { Controller } from "@hotwired/stimulus"

// Desktop windows are non-modal <dialog>s, so several can be open at once and
// their close buttons need no JavaScript. This opens them, drags them by the
// title bar, and brings whichever one you touch to the front.
export default class extends Controller {
  static targets = ["startMenu"]

  #zIndex = 0
  #drag = null

  // Icons open on a double-click, as in Win2k; a single click only selects.
  // Touch and the keyboard (Enter) still open on one tap.
  requireDoubleClick(event) {
    if (event.pointerType === "mouse" && event.detail < 2) {
      event.preventDefault()
      event.stopImmediatePropagation()
    }
  }

  open({ params: { window } }) {
    const dialog = document.getElementById(window)
    dialog.show()
    this.#raise(dialog)
    this.startMenuTarget.togglePopover(false)
  }

  raise({ currentTarget }) {
    this.#raise(currentTarget)
  }

  grab(event) {
    if (event.target.closest("button")) return

    const dialog = event.currentTarget.closest("dialog")
    this.#drag = { dialog, x: event.clientX - dialog.offsetLeft, y: event.clientY - dialog.offsetTop }
    event.currentTarget.setPointerCapture(event.pointerId)
  }

  drag({ clientX, clientY }) {
    if (!this.#drag) return

    const { dialog, x, y } = this.#drag
    dialog.style.left = `${clientX - x}px`
    dialog.style.top = `${clientY - y}px`
  }

  drop() {
    this.#drag = null
  }

  #raise(dialog) {
    dialog.style.zIndex = ++this.#zIndex
  }
}
