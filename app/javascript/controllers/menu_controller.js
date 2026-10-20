import { Controller } from "@hotwired/stimulus"

// Win2k submenus open on hover, at any depth. Clicking still opens them, for
// touch and keyboard.
export default class extends Controller {
  hover({ target }) {
    const item = target.closest("a, button")
    if (!item) return

    // Submenus of one menu are sibling popovers, so opening one closes any
    // other. Hovering a plain item closes whichever is open beside it; the
    // first open popover inside its menu is that one, and closing it closes
    // any opened from it in turn.
    const submenu = item.popoverTargetElement
    if (submenu) {
      submenu.togglePopover(true)
    } else {
      item.closest("[popover]").querySelector(":popover-open")?.hidePopover()
    }
  }
}
