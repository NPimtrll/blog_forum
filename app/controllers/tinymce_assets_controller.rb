class TinymceAssetsController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:file].blank?
      render json: { error: "No file provided" }, status: :unprocessable_entity
      return
    end

    unless params[:file].content_type.start_with?("image/")
      render json: { error: "Invalid file type. Only images are allowed." }, status: :unprocessable_entity
      return
    end

    begin
      image = Image.create!(file: params[:file])
      render json: { location: url_for(image.file) }
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
