class User::JobsController < ApplicationController
  def show
    session[:forwarding_url] = request.url
    @user = User.find_by_slug(params[:user_slug])
    @job = JobPresenter.new(Job.find(params[:id]), view_context)
  end

  def update
    @job = Job.find(params[:id])
    if job_params[:status]
      @job.update_attribute(:status, job_params[:status].to_i)
      if @job.completed?
        redirect_to new_user_job_comment_path(current_user, @job)
      else
        redirect_to dashboard_path
      end
    end
  end

  private

  def job_params
    params.permit(:status)
  end
end
