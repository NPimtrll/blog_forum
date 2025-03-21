class TagsController < ApplicationController
  def find_or_create
    tag = Tag.find_or_create_by(name: params[:name])
    render json: { id: tag.id, name: tag.name }
  end
end
