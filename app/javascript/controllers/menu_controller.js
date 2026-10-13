import { Controller } from "@hotwired/stimulus"

// Win2k submenus open on hover. Clicking still opens them, for touch and keyboard.
export default class extends Controller {
  hover({ target }) {
    const item = target.closest("a, button")
    if (item?.closest("[popover]") !== this.element) return

    // Submenus are sibling popovers, so opening one closes any other.
    const submenu = item.popoverTargetElement
    if (submenu) {
      submenu.togglePopover(true)
    } else {
      this.element.querySelector(":popover-open")?.hidePopover()
    }
  }
}
