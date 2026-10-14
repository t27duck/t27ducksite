import { Controller } from "@hotwired/stimulus"

// Desktop windows are non-modal <dialog>s, so several can be open at once and
// their close buttons need no JavaScript. Their contents are lazy turbo-frames
// (or iframes) that load the first time the window shows. This opens them,
// drags them by the title bar, and brings whichever one you touch to the front.
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
    if (!dialog.open) {
      dialog.show()
      dialog.querySelector(".window-body").scrollTop = 0 // can't scroll while closed, so reset() can't do this
      this.#cascade(dialog)
    }
    this.#raise(dialog)
    this.startMenuTarget.togglePopover(false)
  }

  // Closing a window resets it: it reopens in its cascade spot, and its
  // contents reload now, so they're fresh by the time it opens again.
  reset({ currentTarget: dialog }) {
    dialog.style.top = ""
    dialog.style.left = ""
    dialog.querySelector("turbo-frame[src]")?.reload()
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

  // A window that hasn't been dragged opens down and to the right of the
  // others already open, as Windows cascades them.
  #cascade(dialog) {
    if (dialog.style.top) return

    const others = this.element.querySelectorAll(".desktop-window[open]").length - 1
    dialog.style.top = `${dialog.offsetTop + others * 32}px`
    dialog.style.left = `${dialog.offsetLeft + others * 32}px`
  }

  #raise(dialog) {
    dialog.style.zIndex = ++this.#zIndex
  }
}
