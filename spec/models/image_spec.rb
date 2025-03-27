require 'rails_helper'

RSpec.describe Image, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      image = build(:image, file: fixture_file_upload('spec/fixtures/files/valid_image.jpg', 'image/jpeg'))
      expect(image).to be_valid
    end
  end
end
