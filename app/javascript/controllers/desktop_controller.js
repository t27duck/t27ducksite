import { Controller } from "@hotwired/stimulus"

// Desktop windows are non-modal <dialog>s, so several can be open at once and
// their close buttons need no JavaScript. Each opener passes the window's
// config as an action param (see Desktop::Window), and this builds the window
// from the template when it opens, with a turbo-frame or an iframe that loads
// its contents.
// It also drags windows by the title bar, and brings whichever one you touch
// to the front.
export default class extends Controller {
  static targets = ["startMenu", "template", "windows"]

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
    this.#open(window)
  }

  // Opens the window on window.src, loading it in place of whatever the window
  // already shows if it's open, as a talk replaces the one playing.
  load({ params: { window } }) {
    const contents = this.#open(window).querySelector(".window-body").firstElementChild
    if (new URL(window.src, document.baseURI).href !== new URL(contents.getAttribute("src"), document.baseURI).href) {
      contents.setAttribute("src", window.src)
    }
  }

  // A closed window is thrown away, so it reopens as new: back in its cascade
  // spot, scrolled to the top, with its contents loaded fresh.
  discard({ currentTarget: dialog }) {
    dialog.remove()
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

  #open(window) {
    let dialog = document.getElementById(window.id)
    if (!dialog) {
      dialog = this.#build(window)
      dialog.show()
      this.#cascade(dialog)
    }
    this.#raise(dialog)
    this.startMenuTarget.togglePopover(false)
    return dialog
  }

  // A new window opens down and to the right of the others already open, as
  // Windows cascades them.
  #cascade(dialog) {
    const others = this.element.querySelectorAll(".desktop-window[open]").length - 1
    dialog.style.top = `${dialog.offsetTop + others * 32}px`
    dialog.style.left = `${dialog.offsetLeft + others * 32}px`
  }

  #build({ id, title, src, frame, width, height, kind }) {
    const dialog = this.templateTarget.content.firstElementChild.cloneNode(true)
    dialog.id = id
    dialog.setAttribute("aria-label", title)
    if (kind) dialog.classList.add(kind)
    if (width) dialog.style.width = width
    if (height) dialog.style.height = height
    dialog.querySelector(".titlebar h2").textContent = title
    dialog.querySelector(".window-body").append(frame ? this.#turboFrame(frame, src) : this.#iframe(src, title))

    this.windowsTarget.append(dialog)
    return dialog
  }

  // Files open as full pages, hence target _top.
  #turboFrame(id, src) {
    const frame = document.createElement("turbo-frame")
    frame.id = id
    frame.setAttribute("target", "_top")
    frame.setAttribute("src", src)
    frame.textContent = "Loading…"
    return frame
  }

  // A whole page, which keeps its links to itself.
  #iframe(src, title) {
    const iframe = document.createElement("iframe")
    iframe.src = src
    iframe.title = title
    return iframe
  }

  #raise(dialog) {
    dialog.style.zIndex = ++this.#zIndex
  }
}
