import { Controller } from "@hotwired/stimulus"

// The taskbar clock: the visitor's local time, to the minute.
export default class extends Controller {
  connect() {
    this.tick()
    this.timer = setInterval(() => this.tick(), 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  tick() {
    this.element.textContent = new Date().toLocaleTimeString([], { hour: "numeric", minute: "2-digit" })
  }
}
