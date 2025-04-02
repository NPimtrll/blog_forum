class SearchController < ApplicationController
  def index
    @query = params[:query]

    if @query.present?
      @posts = Post.where("LOWER(title) LIKE ? OR LOWER(content) LIKE ?",
                         "%#{@query.downcase}%",
                         "%#{@query.downcase}%")
                   .includes(:user, :tags)
                   .limit(5)

      @categories = Tag.where("LOWER(name) LIKE ?",
                            "%#{@query.downcase}%")
                      .limit(5)

      @category_posts = Post.joins(:category)
                          .where("LOWER(categories.name) LIKE ?",
                                "%#{@query.downcase}%")
                          .includes(:user, :tags, :category)
                          .limit(5)
    else
      @posts = []
      @categories = []
      @category_posts = []
    end

    respond_to do |format|
      format.html
      format.json do
        render json: {
          posts: @posts.map { |post| { id: post.id, title: post.title, user_email: post.user.email } },
          categories: @categories.map { |tag| { id: tag.id, name: tag.name } },
          category_posts: @category_posts.map { |post| { id: post.id, title: post.title, user_email: post.user.email, category_name: post.category.name } }
        }
      end
    end
  end
end
