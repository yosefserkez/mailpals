import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["toggleable"]
    static values = { class: String }

    connect() {
        if (!this.hasClassValue) {
            this.classValue = "hidden"
        }
    }

    toggle() {
        this.toggleableTargets.forEach(target => {
            target.classList.toggle(this.classValue)
        })
    }

    show() {
        this.toggleableTargets.forEach(target => {
            target.classList.remove(this.classValue)
        })
    }

    hide() {
        this.toggleableTargets.forEach(target => {
            target.classList.add(this.classValue)
        })
    }
}

