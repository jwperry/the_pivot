class CategoriesController < ApplicationController
  def show
    @category = Category.find_by_slug(params[:slug])
    @categories = Category.all.includes(:jobs)
  end
end
