import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["form", "themeSelect"]

    connect() {
        this.updateTheme()
    }

    updateTheme() {
        const newTheme = this.themeSelectTarget.value
        document.body.className = document.body.className.replace(/theme--\w+/, `theme--${newTheme}`)
    }

    change(event) {
        if (event.target === this.themeSelectTarget) {
            this.updateTheme()
        }
    }
}
