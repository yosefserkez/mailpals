import { Controller } from "@hotwired/stimulus"
import Compressor from 'compressorjs'

export default class extends Controller {
  static targets = ["input", "previews"]

  preview() {
    const files = Array.from(this.inputTarget.files)

    if (files.length > 0) {
      this.removePreviews()
    }

    files.forEach(file => {
      new Compressor(file, {
        quality: 0.2, // Adjust this value to balance quality and file size
        mimeType: 'image/jpeg',
        success: (compressedFile) => {
          const reader = new FileReader()
          reader.onload = (e) => {
            const imgContainer = document.createElement('div')
            imgContainer.classList.add('relative', 'group', 'mb-6')

            const img = document.createElement('img')
            img.src = e.target.result
            img.classList.add('local-preview', 'w-20', 'h-20', 'object-cover', 'rounded')

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
          reader.readAsDataURL(compressedFile)
        },
        error: (err) => {
          console.error('Compression error:', err.message)
        }
      })
    })
  }

  markPhotoForDeletion(event) {
    const photoId = event.currentTarget.dataset.photoId
    const checkbox = this.element.querySelector(`input[value="${photoId}"]`)
    checkbox.checked = !checkbox.checked
    const classesToToggle = ['opacity-50']
    classesToToggle.forEach(cls => {
      event.currentTarget.closest('.relative').classList.toggle(cls)
    })
  }

  removePreviews() {
    document.querySelectorAll('.local-preview').forEach(img => img.remove())
  }
}