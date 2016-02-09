class User::JobsController < ApplicationController
  before_action :require_platform_admin, only: [:destroy]

  def show
    session[:forwarding_url] = request.url
    @user = User.find_by_slug(params[:user_slug])
    @job = JobPresenter.new(Job.find(params[:id]), view_context)
  end

  def destroy
    job = Job.find(params[:id])
    category = job.category

    job.destroy

    flash[:success] = "Job Deleted"
    redirect_to category_path(category)
  end

  private

  def require_platform_admin
    render file: "public/404" unless current_platform_admin?
  end
end
