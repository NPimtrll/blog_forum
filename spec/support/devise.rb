RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers
  Warden.test_mode!

  config.after :each do
    Warden.test_reset!
  end
end 