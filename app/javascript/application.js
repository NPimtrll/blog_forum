// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "trix"
import "@rails/actiontext"
import "tinymce"

// Import Rails UJS
import Rails from "@rails/ujs"
Rails.start()
