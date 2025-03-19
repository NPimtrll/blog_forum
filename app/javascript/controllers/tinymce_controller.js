import { Controller } from "@hotwired/stimulus"
import tinymce from "tinymce"
import "tinymce/themes/silver"
import "tinymce/icons/default"
import "tinymce/models/dom"

// Import the plugins you want to use
import "tinymce/plugins/advlist"
import "tinymce/plugins/autolink"
import "tinymce/plugins/lists"
import "tinymce/plugins/link"
import "tinymce/plugins/image"
import "tinymce/plugins/charmap"
import "tinymce/plugins/preview"
import "tinymce/plugins/anchor"
import "tinymce/plugins/searchreplace"
import "tinymce/plugins/visualblocks"
import "tinymce/plugins/code"
import "tinymce/plugins/fullscreen"
import "tinymce/plugins/insertdatetime"
import "tinymce/plugins/media"
import "tinymce/plugins/table"
import "tinymce/plugins/help"
import "tinymce/plugins/wordcount"

export default class extends Controller {
  connect() {
    tinymce.init({
      selector: '.tinymce',
      plugins: [
        'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
        'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
        'insertdatetime', 'media', 'table', 'help', 'wordcount'
      ],
      toolbar: 'undo redo | blocks fontfamily fontsize | bold italic underline strikethrough | link image media table | align lineheight | numlist bullist indent outdent | emoticons charmap | removeformat',
      height: 500,
      menubar: 'file edit view insert format tools table help',
      content_style: 'body { font-family: -apple-system, BlinkMacSystemFont, San Francisco, Segoe UI, Roboto, Helvetica Neue, sans-serif; font-size: 14px; }',
      setup: function(editor) {
        editor.on('init', function() {
          editor.getContainer().style.transition = "border-color 0.15s ease-in-out"
        })
      }
    })
  }
} 