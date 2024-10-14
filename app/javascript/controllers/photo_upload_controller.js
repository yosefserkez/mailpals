import { Controller } from "@hotwired/stimulus"
import Compressor from 'compressorjs'

export default class extends Controller {
  static targets = ["input", "previews"]

  connect() {
    this.fileCounter = 0
  }

  preview() {
    const files = Array.from(this.inputTarget.files)

    files.forEach(file => {
      new Compressor(file, {
        quality: 0.2, // Adjust this value to balance quality and file size
        success: (compressedFile) => {
          const fileName = `compressed_${this.fileCounter}_${file.name}`
          this.fileCounter++
          this.createPreview(compressedFile, fileName)
          this.attachCompressedFile(compressedFile, fileName)
        },
        error: (err) => {
          console.error('Compression error:', err.message)
        }
      })
    })

    this.inputTarget.value = '' // Clear the file input
  }

  createPreview(file, fileName) {
    const reader = new FileReader()
    reader.onload = (e) => {
      const imgContainer = document.createElement('div')
      imgContainer.classList.add('relative', 'group', 'mb-6')
      imgContainer.dataset.fileName = fileName

      const img = document.createElement('img')
      img.src = e.target.result
      img.classList.add('local-preview', 'w-20', 'h-20', 'object-cover', 'rounded')

      const deleteOverlay = document.createElement('div')
      deleteOverlay.classList.add('absolute', 'inset-0', 'bg-black', 'bg-opacity-50', 'flex', 'items-center', 'justify-center', 'opacity-0', 'group-hover:opacity-100', 'transition-opacity')

      const deleteButton = document.createElement('button')
      deleteButton.textContent = 'Delete'
      deleteButton.classList.add('text-white')
      deleteButton.addEventListener('click', () => {
        imgContainer.remove()
        this.removeAttachedFile(fileName)
      })

      deleteOverlay.appendChild(deleteButton)
      imgContainer.appendChild(img)
      imgContainer.appendChild(deleteOverlay)
      this.previewsTarget.appendChild(imgContainer)
    }
    reader.readAsDataURL(file)
  }

  attachCompressedFile(file, fileName) {
    const dataTransfer = new DataTransfer()
    dataTransfer.items.add(new File([file], fileName, { type: file.type }))

    const hiddenInput = document.createElement('input')
    hiddenInput.type = 'file'
    hiddenInput.name = `${this.inputTarget.name}`
    hiddenInput.style.display = 'none'
    hiddenInput.files = dataTransfer.files
    hiddenInput.dataset.fileName = fileName

    this.element.appendChild(hiddenInput)
  }

  removeAttachedFile(fileName) {
    const hiddenInput = this.element.querySelector(`input[data-file-name="${fileName}"]`)
    if (hiddenInput) {
      hiddenInput.remove()
    }
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
}
