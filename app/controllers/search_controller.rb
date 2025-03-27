class SearchController < ApplicationController
  def index
    @query = params[:q]
    return unless @query.present?

    @posts = Post.where("title ILIKE ? OR content ILIKE ?", "%#{@query}%", "%#{@query}%")
                .includes(:user, :category)
                .order(created_at: :desc)
                .page(params[:page])
                .per(10)

    @users = User.where("username ILIKE ? OR full_name ILIKE ?", "%#{@query}%", "%#{@query}%")
                .order(created_at: :desc)
                .page(params[:page])
                .per(10)

    @categories = Category.where("name ILIKE ? OR description ILIKE ?", "%#{@query}%", "%#{@query}%")
                        .order(created_at: :desc)
                        .page(params[:page])
                        .per(10)

    respond_to do |format|
      format.html
      format.json do
        render json: {
          posts: @posts.map { |post| { id: post.id, title: post.title, user_email: post.user.email } },
          users: @users.map { |user| { id: user.id, username: user.username } },
          categories: @categories.map { |category| { id: category.id, name: category.name } }
        }
      end
    end
  end
end
