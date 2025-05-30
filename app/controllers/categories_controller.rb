class CategoriesController < ApplicationController
  before_action :set_category, only: [ :show, :edit, :update, :destroy ]
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]

  def index
    @categories = Category.all
  end

  def show
    @posts = @category.posts.includes(:user).order(created_at: :desc)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to @category, notice: "Category created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: "Category updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: "Category was successfully destroyed"
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
