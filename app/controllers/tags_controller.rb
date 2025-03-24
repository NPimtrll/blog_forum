class TagsController < ApplicationController
  def find_or_create
    tag = Tag.find_or_create_by(name: params[:name])
    render json: { id: tag.id, name: tag.name }
  end

  def trending
    @tags = Tag.trending(5)
    render json: @tags.as_json(only: [ :id, :name ], methods: [ :post_count ])
  end
end
