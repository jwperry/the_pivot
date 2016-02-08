class User::JobsController < ApplicationController
  before_action :set_duration_tags, only: [:show]

  def show
    @user = User.find_by_slug(params[:user_slug])
    @job = Job.find(params[:id])
  end

  def edit
  end

  def update
    @job = Job.find(params[:id])
    if job_params[:status]
      @job.update_attribute(:status, job_params[:status].to_i)
      current_user.reload
      if @job.completed?
        redirect_to new_user_job_comment_path(current_user, @job)
      else
        redirect_to dashboard_path
      end
    end
  end

  private

  def set_duration_tags
    @duration_tags = [
      ["Short (1 week or less)", 0],
      ["Medium (1 - 4 weeks)", 1],
      ["Long (Longer than 4 weeks)", 2],
      ["Event (Specific date & time)", 3]
    ]
  end

  def job_params
    params.permit(:status)
  end
end
