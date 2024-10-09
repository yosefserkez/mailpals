// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "input", "confirmButtonParent"]
  static values = { requiredInput: String }

  connect() {
    if (this.hasRequiredInputValue && this.requiredInputValue) {
      this.disableConfirmButton(true)
    }
  }

  open() {
    this.modalTarget.classList.remove("hidden")
  }

  close() {
    this.modalTarget.classList.add("hidden")
  }

  checkInput() {
    if (this.hasRequiredInputValue && this.requiredInputValue) {
      const isDisabled = this.inputTarget.value !== this.requiredInputValue
      this.disableConfirmButton(isDisabled)
    }
  }

  disableConfirmButton(disabled) {
    if (!this.hasConfirmButtonParentTarget || !this.confirmButtonParentTarget) return
    const button = this.confirmButtonParentTarget.querySelector('button, a')
    if (button) {
      button.disabled = disabled
      button.classList.toggle('disabled', disabled)
      button.classList.toggle('pointer-events-none', disabled)

    }
  }
}