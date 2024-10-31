import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content", "button", "buttonText", "icon"];

  toggle() {
    const isHidden = this.contentTarget.classList.toggle("hidden");
    this.iconTarget.classList.toggle("rotate-180", !isHidden);
  }
}
