import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]
  static values = { autoDismiss: Number }

  connect() {
    if (this.hasMessageTarget) {
      this.show()
      this.autoDismissTimeout = setTimeout(() => {
        this.hide()
      }, this.autoDismissValue)
    }
  }

  disconnect() {
    if (this.autoDismissTimeout) {
      clearTimeout(this.autoDismissTimeout)
    }
  }

  show() {
    this.element.classList.remove("hidden")
  }

  hide() {
    this.element.classList.add("hidden")
  }

  close() {
    this.hide()
    if (this.autoDismissTimeout) {
      clearTimeout(this.autoDismissTimeout)
    }
  }
}