import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content", "icon"];

  toggle() {
    if (!this.hasContentTarget || !this.hasIconTarget) return;

    const content = this.contentTarget;
    const isHidden = content.classList.contains("max-h-0");
    const maxHeight = isHidden ? `${content.scrollHeight}px` : "0";

    content.classList.toggle("max-h-0", !isHidden);
    content.style.maxHeight = maxHeight;
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
