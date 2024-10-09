import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["buttonText", "spinner"]

  disable(event) {
    this.element.value = "Submitting..."
    this.element.classList.add("opacity-90")
    this.element.classList.add("cursor-not-allowed")
    this.element.classList.add("animate-pulse")
  }
}
