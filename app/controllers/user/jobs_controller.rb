class User::JobsController < ApplicationController
  before_action :require_platform_admin, only: [:destroy]
  before_action :update_params, only: [:update]

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

  def update
    @job = Job.find(params[:id])

    if job_params[:status]
      @job.update_attributes(job_params)

      if @job.completed?
        redirect_to new_user_job_comment_path(current_user, @job)
      else
        redirect_to dashboard_path
      end
    end
  end

  private

  def require_platform_admin
    render file: "public/404" unless current_platform_admin?
  end

  def job_params
    params.permit(:status)
  end

  def update_params
    params[:status] = params[:status].to_i
  end
end
