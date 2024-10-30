import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content", "button", "buttonText", "icon"];

  toggle() {
    this.contentTarget.classList.toggle("hidden");
    this.iconTarget.classList.toggle("rotate-180");

    const isHidden = this.contentTarget.classList.contains("hidden");
    this.buttonTextTarget.textContent = isHidden
      ? "Show Inactive Clubs"
      : "Hide Inactive Clubs";
  }
}
