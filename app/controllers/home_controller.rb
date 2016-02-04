class HomeController < ApplicationController
  def index
    @categories = Category.all
    render layout: "home"
  end
end
