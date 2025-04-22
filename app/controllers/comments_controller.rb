class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: %i[edit update destroy]
  before_action :authorize_comment_owner, only: %i[edit update destroy]
  before_action :store_return_to, only: [ :create, :update, :destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    @post = Post.find(params[:post_id])
  end

  # GET /comments/1/edit
  def edit
    @post = @comment.post
  end

  # POST /comments or /comments.json
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.parent_id = params[:parent_id] if params[:parent_id].present?

    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_path(@post, anchor: "comment-#{@comment.id}"), notice: "Comment was successfully created." }
        format.turbo_stream
      else
        format.html { redirect_to post_path(@post), alert: "Failed to add comment." }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("comment_form", partial: "comments/form", locals: { post: @post, comment: @comment }) }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    if @comment.update(comment_params)
      redirect_to @post, notice: "Comment was successfully updated."
    else
      redirect_to @post, alert: "Failed to update comment."
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy!
    redirect_to @post, notice: "Comment was successfully destroyed.", status: :see_other
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

    def store_return_to
      session[:return_to] = request.referer if request.referer.present? && !request.referer.include?("/comments")
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find_by(id: params[:id], post_id: @post.id)
      redirect_to @post, alert: "Comment not found" if @comment.nil?
    end

    def authorize_comment_owner
      redirect_to @post, alert: "You are not authorized to modify this comment." unless @comment.user == current_user
    end

    def comment_params
      params.require(:comment).permit(:content, :parent_id)
    end
end
