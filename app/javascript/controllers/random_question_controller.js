import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["prompt", "askedBy", "errorMessage"]

  connect() {
    console.log("Random question controller connected")
  }

  fetchRandom() {
    const clubId = this.element.dataset.clubId
    this.errorMessageTarget.textContent = "" // Clear any previous error messages

    console.log("Fetching random question for club ID:", clubId)
    fetch(`/clubs/${clubId}/random_question`, {
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      return response.json()
    })
    .then(data => {
      this.promptTarget.value = data.prompt
      this.askedByTarget.value = data.asked_by
    })
    .catch(error => {
      console.error('Error:', error)
      this.errorMessageTarget.textContent = "An error occurred while fetching a random question. Please try again."
    })
  }
}