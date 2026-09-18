import { Controller } from "@hotwired/stimulus"
import { highlightCode } from "lexxy"

// Lexxy bundles Prism but only highlights inside the editor. Rendered content
// has to be highlighted explicitly. highlightCode marks what it touches with
// data-highlighted, so re-running it on a Turbo-restored page is a no-op.
export default class extends Controller {
  connect() {
    highlightCode(this.element)
  }
}
