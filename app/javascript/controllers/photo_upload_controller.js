import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "previews"]

  preview() {
    const files = Array.from(this.inputTarget.files)

    files.forEach(file => {
      const reader = new FileReader()
      reader.onload = (e) => {
        const imgContainer = document.createElement('div')
        imgContainer.classList.add('relative', 'group')

        const img = document.createElement('img')
        img.src = e.target.result
        img.classList.add('w-20', 'h-20', 'object-cover', 'rounded')
        
        const deleteOverlay = document.createElement('div')
        deleteOverlay.classList.add('absolute', 'inset-0', 'bg-black', 'bg-opacity-50', 'flex', 'items-center', 'justify-center', 'opacity-0', 'group-hover:opacity-100', 'transition-opacity')
        
        const deleteButton = document.createElement('button')
        deleteButton.textContent = 'Delete'
        deleteButton.classList.add('text-white')
        deleteButton.addEventListener('click', () => imgContainer.remove())

        deleteOverlay.appendChild(deleteButton)
        imgContainer.appendChild(img)
        imgContainer.appendChild(deleteOverlay)
        this.previewsTarget.appendChild(imgContainer)
      }
      reader.readAsDataURL(file)
    })
  }

  markPhotoForDeletion(event) {
    const photoId = event.currentTarget.dataset.photoId
    const checkbox = this.element.querySelector(`input[value="${photoId}"]`)
    checkbox.checked = !checkbox.checked
    event.currentTarget.closest('.relative').classList.toggle('opacity-50')
  }

  toggleDeletePhoto(event) {
    const container = event.target.closest('.relative')
    if (event.target.checked) {
      container.classList.add('opacity-50')
    } else {
      container.classList.remove('opacity-50')
    }
  }
}