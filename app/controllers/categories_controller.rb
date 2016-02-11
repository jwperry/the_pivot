class CategoriesController < ApplicationController
  before_action :require_platform_admin, only: [:new, :create]

  def show
    category = Category.includes(jobs: :user).find_by_slug(params[:slug])
    jobs = category.jobs.bidding_open.paginate(page: params[:page])
    categories = Category.all
    @category = CategoryPresenter.new(category, jobs, categories, view_context)
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

  def require_platform_admin
    render file: "public/404" unless current_platform_admin?
  end
end
