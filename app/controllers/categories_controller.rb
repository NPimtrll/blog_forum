class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_category, only: [:show]

  def index
    @categories = Category.all
  end

  def show
    @posts = @category.posts.includes(:user, :comments, :likes).order(created_at: :desc)
  end

  def new
    @category = Category.new
  end

  def create
    Rails.logger.info "Creating new category with params: #{params.inspect}"
    @category = Category.new(category_params)

    if @category.save
      Rails.logger.info "Category saved successfully: #{@category.inspect}"
      respond_to do |format|
        format.html { redirect_to @category, notice: "Category was successfully created." }
        format.turbo_stream do
          Rails.logger.info "Rendering turbo stream response"
          render turbo_stream: turbo_stream.append("categories", partial: "posts/category_option", locals: { category: @category })
        end
      end
    else
      Rails.logger.error "Failed to save category: #{@category.errors.full_messages}"
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          Rails.logger.info "Rendering error turbo stream response"
          render turbo_stream: turbo_stream.update("category_error", partial: "shared/error_messages", locals: { object: @category })
        end
      end
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Category not found"
    redirect_to root_path
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
