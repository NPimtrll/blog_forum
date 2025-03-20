require "tinymce-rails"

Rails.application.config.tinymce.configure do |config|
  config.default = {
    theme: "silver",
    selector: ".tinymce",
    plugins: %w[
      advlist autolink lists link image charmap preview
      anchor searchreplace visualblocks code fullscreen
      insertdatetime media table help wordcount
      image_upload
      paste
      textpattern
      nonbreaking
      table
      code
      fullscreen
      directionality
      visualchars
      visualblocks
      template
      hr
      pagebreak
      print
      preview
      searchreplace
      noneditable
      quickbars
      emoticons
      codesample
      toc
      help
    ],
    toolbar: "undo redo | styles | bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | removeformat | fullscreen",
    height: 500,
    menubar: "file edit view insert format tools table help",
    content_style: "body { font-family: -apple-system, BlinkMacSystemFont, San Francisco, Segoe UI, Roboto, Helvetica Neue, sans-serif; font-size: 14px; }",
    images_upload_url: "/tinymce_assets",
    images_upload_handler: ->(blob_info, success, failure) {
      image = Image.create!(file: blob_info[:file])
      success.call(location: image.file.url)
    },
    automatic_uploads: true,
    file_picker_types: "image",
    image_advtab: true,
    image_dimensions: true,
    image_class_list: [
      { title: "Responsive", value: "img-fluid" },
      { title: "Thumbnail", value: "img-thumbnail" },
      { title: "Rounded", value: "rounded" }
    ],
    image_caption: true,
    image_title: true,
    style_formats: [
      { title: "Headers", items: [
        { title: "Header 1", format: "h1", styles: { 'font-size': "2.5em", 'font-weight': "bold", 'margin-bottom': "0.5em" } },
        { title: "Header 2", format: "h2", styles: { 'font-size': "2em", 'font-weight': "bold", 'margin-bottom': "0.5em" } },
        { title: "Header 3", format: "h3", styles: { 'font-size': "1.75em", 'font-weight': "bold", 'margin-bottom': "0.5em" } },
        { title: "Header 4", format: "h4", styles: { 'font-size': "1.5em", 'font-weight': "bold", 'margin-bottom': "0.5em" } },
        { title: "Header 5", format: "h5", styles: { 'font-size': "1.25em", 'font-weight': "bold", 'margin-bottom': "0.5em" } },
        { title: "Header 6", format: "h6", styles: { 'font-size': "1em", 'font-weight': "bold", 'margin-bottom': "0.5em" } }
      ] },
      { title: "Inline", items: [
        { title: "Bold", format: "bold" },
        { title: "Italic", format: "italic" },
        { title: "Underline", format: "underline" },
        { title: "Strikethrough", format: "strikethrough" }
      ] },
      { title: "Blocks", items: [
        { title: "Paragraph", format: "p" },
        { title: "Blockquote", format: "blockquote" },
        { title: "Div", format: "div" },
        { title: "Pre", format: "pre" }
      ] },
      { title: "Alignment", items: [
        { title: "Left", format: "alignleft" },
        { title: "Center", format: "aligncenter" },
        { title: "Right", format: "alignright" },
        { title: "Justify", format: "alignjustify" }
      ] }
    ],
    formats: {
      alignleft: { selector: "p,h1,h2,h3,h4,h5,h6,td,th,div,img", classes: "text-left" },
      aligncenter: { selector: "p,h1,h2,h3,h4,h5,h6,td,th,div,img", classes: "text-center" },
      alignright: { selector: "p,h1,h2,h3,h4,h5,h6,td,th,div,img", classes: "text-right" },
      alignjustify: { selector: "p,h1,h2,h3,h4,h5,h6,td,th,div,img", classes: "text-justify" }
    }
  }
end
