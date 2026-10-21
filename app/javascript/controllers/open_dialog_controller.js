import { Controller } from "@hotwired/stimulus"

// The Open dialog (desktop/_open_dialog). Clicking a file selects it and fills
// in File name; the Open button then opens the selection as if it had been
// double-clicked. Opening a file closes the dialog, and closing it any way
// clears the selection for next time.
export default class extends Controller {
  static targets = ["fileName", "openButton"]

  #selected = null

  select({ currentTarget }) {
    this.#selected?.classList.remove("selected")
    this.#selected = currentTarget
    currentTarget.classList.add("selected")
    this.fileNameTarget.value = currentTarget.textContent.trim()
    this.openButtonTarget.disabled = false
  }

  open() {
    this.#selected?.click()
  }

  close() {
    this.element.close()
  }

  reset() {
    this.#selected?.classList.remove("selected")
    this.#selected = null
    this.fileNameTarget.value = ""
    this.openButtonTarget.disabled = true
  }
}
