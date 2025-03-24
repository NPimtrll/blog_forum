import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list"];

  connect() {
    this.loadTrendingTags();
  }

  async loadTrendingTags() {
    try {
      const response = await fetch("/tags/trending");
      if (!response.ok) throw new Error("Failed to fetch trending tags");

      const tags = await response.json();
      this.renderTags(tags);
    } catch (error) {
      console.error("Error loading trending tags:", error);
    }
  }

  renderTags(tags) {
    this.listTarget.innerHTML = tags
      .map(
        (tag) => `
        <div class="flex items-center justify-between">
          <span class="text-sm text-gray-600">#${tag.name}</span>
          <span class="text-sm text-gray-500">${tag.post_count} articles</span>
        </div>`
      )
      .join("");
  }
}
