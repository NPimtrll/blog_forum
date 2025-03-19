require "test_helper"

class TinymceAssetsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get tinymce_assets_create_url
    assert_response :success
  end
end
