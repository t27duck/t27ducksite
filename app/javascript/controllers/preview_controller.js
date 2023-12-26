import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

export default class extends Controller {
  static targets = ["content", "output"]
  static values = { url: String }

  async show(event) {
    event.preventDefault()

    const response = await post(this.urlValue, { body: JSON.stringify({ content: this.contentTarget.value }) })
    if (response.ok) {
      this.outputTarget.innerHTML = await response.text
    }
  }
}
