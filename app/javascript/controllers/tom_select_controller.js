import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
    connect() {
        new TomSelect(this.element, {
            plugins: ['remove_button'],
            persist: false,
            createOnBlur: true,
            create: false
        })
    }
}