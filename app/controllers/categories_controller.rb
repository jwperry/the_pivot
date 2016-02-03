class CategoriesController < ApplicationController
  def show
    @category = Category.find_by_slug(params[:slug])
    @category_names = Category.pluck(:name)
  end
end
