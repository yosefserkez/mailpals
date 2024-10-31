import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content", "button", "buttonText", "icon"];

  toggle() {
    const content = this.contentTarget;
    const isExpanded = content.style.height !== "0px";
    
    if (!isExpanded) {
      content.style.height = `${content.scrollHeight}px`;
    } else {
      content.style.height = "0px";
    }
    
    this.iconTarget.classList.toggle("rotate-180", !isExpanded);
  }

  connect() {
    this.contentTarget.style.height = "0px";
  }
}
