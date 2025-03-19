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
    ],
    toolbar: "undo redo | formatselect | bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | removeformat",
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
    image_title: true
  }
end
