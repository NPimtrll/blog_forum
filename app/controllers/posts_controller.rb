class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [ :index, :show, :popular ]
  before_action :authorize_post_owner, only: [ :edit, :update, :destroy ]

  # GET /posts or /posts.json
  def index
    if params[:query].present?
      # ถ้ามีคำค้นหาให้แสดงผลลัพธ์การค้นหา
      @posts = Post.where("title ILIKE ? OR content ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    else
      # ถ้าไม่มีคำค้นหาแสดงโพสต์ทั้งหมดตามปกติ
      @posts = Post.includes(:user, :comments, :likes, :category).order(created_at: :desc)
    end
    @popular_posts = Post.order(views: :desc).limit(2)
    @latest_posts = case params[:filter]
    when "today"
                      Post.where("created_at >= ?", Time.zone.now.beginning_of_day)
    when "this_week"
                      Post.where("created_at >= ?", Time.zone.now.beginning_of_week)
    when "this_month"
                      Post.where("created_at >= ?", Time.zone.now.beginning_of_month)
    else
                      Post.all
    end
    @latest_limit_posts = @latest_posts.order(created_at: :desc).limit(2)
    @head_posts = Post.order(created_at: :desc).limit(5)
    @trending_tags = Tag.trending(5)
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.includes(:comments, :likes, :category).find(params[:id])
    @post.increment!(:views)
  end

  # GET /posts/new
  def new
    @post = Post.new
    @categories = Category.all
  end

  # GET /posts/1/edit
  def edit
    @categories = Category.all
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params.except(:tag_names))
    @categories = Category.all

    respond_to do |format|
      if @post.save
        update_tags(@post, params[:post][:tag_names]) if params[:post][:tag_names].present?
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def search
    query = params[:query].strip
    # เปลี่ยนจาก ILIKE เป็น LIKE
    @posts = Post.joins(:category).where("title LIKE ? OR content LIKE ? OR categories.name LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%").limit(5)
    render json: @posts.map { |post| { id: post.id, title: post.title } }
  end


  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    @categories = Category.all
    respond_to do |format|
      if @post.update(post_params.except(:tag_names))
        update_tags(@post, params[:post][:tag_names]) if params[:post][:tag_names].present?
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def popular
    @posts = Post.includes(:user, :comments, :likes, :category).order(views: :desc)
  end

  def latest
    @posts = Post.includes(:user, :comments, :likes, :category).order(created_at: :desc)
  end

  def tagged
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.includes(:user, :comments, :likes, :category)
  end

  private
    def authorize_post_owner
      redirect_to root_path, alert: "You are not authorized to modify this post." unless @post.user == current_user
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :excerpt, :cover_image, :category_id, tag_names: []).merge(user_id: current_user.id)
    end

    def update_tags(post, tag_names)
      post.tags = tag_names.map { |name| Tag.find_or_create_by(name: name.strip) }
    end
end
