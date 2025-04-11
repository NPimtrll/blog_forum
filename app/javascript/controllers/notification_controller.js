import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ["bell", "count", "list"]

  connect() {
    this.channel = consumer.subscriptions.create(
      { channel: "NotificationChannel" },
      {
        received: this.handleNotification.bind(this)
      }
    )
  }

  disconnect() {
    if (this.channel) {
      this.channel.unsubscribe()
    }
  }

  handleNotification(data) {
    // Update unread count
    const currentCount = parseInt(this.countTarget.textContent) || 0
    this.countTarget.textContent = currentCount + 1
    this.countTarget.classList.remove("hidden")

    // Add new notification to the list
    const parser = new DOMParser()
    const doc = parser.parseFromString(data.html, "text/html")
    const notification = doc.body.firstChild

    if (this.hasListTarget) {
      const firstChild = this.listTarget.firstChild
      if (firstChild) {
        this.listTarget.insertBefore(notification, firstChild)
      } else {
        this.listTarget.appendChild(notification)
      }
    }
  }
} 