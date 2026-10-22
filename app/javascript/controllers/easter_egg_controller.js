import { Controller } from "@hotwired/stimulus"

// The way into Solitaire from any page: the Konami code, or five quick taps on
// the footer's copyright.
const KONAMI = ["ArrowUp", "ArrowUp", "ArrowDown", "ArrowDown", "ArrowLeft", "ArrowRight", "ArrowLeft", "ArrowRight", "b", "a"]
const TAPS = 5
const TAP_GAP = 1000

export default class extends Controller {
  static outlets = ["solitaire-window"]

  #keys = 0
  #taps = 0
  #lastTap = 0

  key(event) {
    if (this.#typing(event.target)) return

    const key = event.key.length === 1 ? event.key.toLowerCase() : event.key
    if (key === KONAMI[this.#keys]) {
      this.#keys++
    } else {
      // A wrong key may still start the code over, as a third ArrowUp does.
      this.#keys = key === KONAMI[0] ? 1 : 0
    }

    if (this.#keys === KONAMI.length) {
      this.#keys = 0
      this.solitaireWindowOutlet.open()
    }
  }

  tap() {
    const now = Date.now()
    this.#taps = now - this.#lastTap > TAP_GAP ? 1 : this.#taps + 1
    this.#lastTap = now

    if (this.#taps === TAPS) {
      this.#taps = 0
      this.solitaireWindowOutlet.open()
    }
  }

  #typing(target) {
    return target.isContentEditable || ["INPUT", "TEXTAREA", "SELECT"].includes(target.tagName)
  }
}
