// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "input", "confirmButtonParent"]
  static values = {
    requiredInput: String,
    openOnConnect: Boolean
  }

  connect() {
    if (this.hasRequiredInputValue && this.requiredInputValue) {
      this.disableConfirmButton(true)
    }
    if (this.openOnConnectValue) {
      this.open()
    }
  }

  open() {
    this.modalTarget.classList.remove("hidden")
    document.body.classList.add("modal-open")
  }

  close() {
    this.modalTarget.classList.add("hidden")
    document.body.classList.remove("modal-open")
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
