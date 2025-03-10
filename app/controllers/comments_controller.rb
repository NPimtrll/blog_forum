class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: %i[edit update destroy]
  before_action :authorize_comment_owner, only: %i[edit update destroy]

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
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: "Comment was successfully created."
    else
      redirect_to @post, alert: "Failed to add comment."
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

    respond_to do |format|
      format.html { redirect_to @post, status: :see_other, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = @post.comments.find(params[:id])
    end

    def authorize_comment_owner
      redirect_to @post, alert: "You are not authorized to modify this comment." unless @comment.user == current_user
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
