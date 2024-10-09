// app/javascript/controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }
  connect() {
    document.addEventListener("click", this.closeDropdown.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.closeDropdown.bind(this))
  }

  closeDropdown(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }

  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
  }
}