import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('change', this.submit.bind(this))
  }

  submit() {
    this.element.form.requestSubmit()
    setTimeout(() => window.location.reload(), 100)
  }
}
