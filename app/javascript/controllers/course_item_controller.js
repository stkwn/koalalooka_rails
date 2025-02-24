import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "form", "term", "content", "newItemForm", "addNewBtn", "deleteBtn"]
  
  connect() {
    console.log("Course Item controller connected")
  }
  static values = {
    id: String,
    courseId: String
  }

  edit(event) {
    event.preventDefault()
    console.log('edit')
    const row = event.currentTarget.closest("tr[data-course-item-id-value]")
    if (!row) return
    
    const id = row.dataset.courseItemIdValue
    this.idValue = id
    
    const term = row.querySelector("td:first-child").textContent.trim()
    const content = row.querySelector("td:nth-child(2)").textContent.trim()
    
    row.innerHTML = `
      <td>
        <input type="text" class="form-control" data-course-item-target="term" value="${term}">
      </td>
      <td>
        <input type="text" class="form-control" data-course-item-target="content" value="${content}">
      </td>
      <td>
        <button class="btn btn-success btn-sm me-2" data-action="click->course-item#save">Save</button>
        <button class="btn btn-secondary btn-sm" data-action="click->course-item#cancel">Cancel</button>
      </td>
    `
  }

  save() {
    const term = this.termTarget.value
    const content = this.contentTarget.value

    if (!term || !content) {
      alert('Please fill in both fields')
      return
    }

    fetch(`/courses/${this.courseIdValue}/course_items/${this.idValue}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        course_item: {
          term: term,
          content: { "0": content }
        }
      })
    })
    .then(response => {
      return response.json().then(data => {
        if (!response.ok) {
          throw new Error(data.message || 'Failed to save')
        }
        window.location.href = `/courses/${this.courseIdValue}`
      })
    })
    .catch(error => {
      console.error('Save error:', error)
      // Don't show error if page is reloading
      if (!window.isReloading) {
        alert('Error saving item: ' + error.message)
      }
    })
  }

  cancel(event) {
    window.location.reload()
  }

  showNewForm() {
    console.log('showNewForm')
    this.newItemFormTarget.style.display = 'table-row'
    this.addNewBtnTarget.style.display = 'none'
  }

  hideNewForm() {
    console.log('hideNewForm')
    this.newItemFormTarget.style.display = 'none'
    this.addNewBtnTarget.style.display = 'block'
    this.newItemFormTarget.querySelector('#newTerm').value = ''
    this.newItemFormTarget.querySelector('#newContent').value = ''
  }

  saveNew() {
    console.log('saveNew')
    const term = this.newItemFormTarget.querySelector('#newTerm').value
    const content = this.newItemFormTarget.querySelector('#newContent').value
    
    if (!term || !content) {
      alert('Please fill in both fields')
      return
    }

    fetch(`/courses/${this.courseIdValue}/course_items`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        course_item: {
          term: term,
          content: { "0": content }
        }
      })
    })
    .then(response => {
      return response.json().then(data => {
        if (!response.ok) {
          throw new Error(data.message || 'Failed to save')
        }
        window.location.href = `/courses/${this.courseIdValue}`
      })
    })
    .catch(error => {
      console.error('Save error:', error)
      // Don't show error if page is reloading
      if (!window.isReloading) {
        alert('Error saving item: ' + error.message)
      }
    })
  }

  delete(event) {
    event.preventDefault()
    if (!confirm('Are you sure?')) return

    const row = event.currentTarget.closest("tr[data-course-item-id-value]")
    if (!row) return
    
    const id = row.dataset.courseItemIdValue
    
    fetch(`/courses/${this.courseIdValue}/course_items/${id}`, {
      method: 'DELETE',
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => {
      return response.json().then(data => {
        if (!response.ok) {
          throw new Error(data.message || 'Failed to delete')
        }
        window.location.href = `/courses/${this.courseIdValue}`
      })
    })
    .catch(error => {
      console.error('Delete error:', error)
      alert('Error deleting item: ' + error.message)
    })
  }
}
