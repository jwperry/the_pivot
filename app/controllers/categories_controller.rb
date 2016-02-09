class CategoriesController < ApplicationController
  def show
    @category = Category.find_by_slug(params[:slug])
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to category_path(@category)
    else
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
