class TinymceAssetsController < ApplicationController
  def create
    image = Image.create!(file: params[:file])
    render json: { location: url_for(image.file) }
  end
end
