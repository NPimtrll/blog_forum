import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "results"]
    static values = {
        url: String
    }

    connect() {
        this.timeout = null
    }

    search(event) {
        clearTimeout(this.timeout)
        const query = event.target.value.trim()

        if (query.length < 2) {
            this.hideResults()
            return
        }

        this.timeout = setTimeout(() => {
            this.performSearch(query)
        }, 300)
    }

    async performSearch(query) {
        try {
            const response = await fetch(`/search?query=${encodeURIComponent(query)}`, {
                headers: {
                    "Accept": "application/json",
                    "X-Requested-With": "XMLHttpRequest"
                }
            })
            const data = await response.json()
            this.displayResults(data)
        } catch (error) {
            console.error("Search error:", error)
        }
    }

    displayResults(data) {
        let html = '<div class="p-4">'

        if (data.posts && data.posts.length > 0) {
            html += `
                <div class="mb-4">
                    <h3 class="text-sm font-semibold text-gray-500 mb-2">บทความที่เกี่ยวข้อง</h3>
                    <div class="space-y-2">
                        ${data.posts.map(post => `
                            <a href="/posts/${post.id}" class="block p-2 hover:bg-gray-50 rounded-lg">
                                <div class="text-sm font-medium text-gray-900">${post.title}</div>
                                <div class="text-xs text-gray-500">โดย ${post.user_email}</div>
                            </a>
                        `).join('')}
                    </div>
                </div>
            `
        }

        if (data.categories && data.categories.length > 0) {
            html += `
                <div>
                    <h3 class="text-sm font-semibold text-gray-500 mb-2">หมวดหมู่ที่เกี่ยวข้อง</h3>
                    <div class="space-y-2">
                        ${data.categories.map(tag => `
                            <a href="/posts/tagged?tag=${encodeURIComponent(tag.name)}" class="block p-2 hover:bg-gray-50 rounded-lg">
                                <div class="text-sm font-medium text-gray-900">#${tag.name}</div>
                            </a>
                        `).join('')}
                    </div>
                </div>
            `
        }

        if ((!data.posts || data.posts.length === 0) && (!data.categories || data.categories.length === 0)) {
            html += `
                <div class="text-sm text-gray-500 text-center py-4">
                    ไม่พบผลลัพธ์ที่เกี่ยวข้อง
                </div>
            `
        }

        html += '</div>'
        this.resultsTarget.innerHTML = html
        this.showResults()
    }

    showResults() {
        this.resultsTarget.classList.remove("hidden")
    }

    hideResults(event) {
        if (event && this.resultsTarget.contains(event.target)) {
            return
        }
        this.resultsTarget.classList.add("hidden")
    }
} 