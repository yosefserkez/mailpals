import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content", "icon"];

  toggle() {
    const content = this.contentTarget;
    const isHidden = content.classList.contains("max-h-0");

    content.classList.toggle("max-h-0", !isHidden);
    content.classList.toggle("max-h-[500px]", isHidden);
    this.iconTarget.classList.toggle("rotate-180", isHidden);
  }

  connect() {
    if (!this.hasContentTarget) return;
    this.contentTarget.classList.add(
      "overflow-hidden",
      "transition-all",
      "duration-300",
      "ease-in-out",
      "max-h-0"
    );
  }
}
