class HomeController < ApplicationController
  def index
    @category_names = Category.all.pluck(:name)
    render layout: "home"
  end
end
