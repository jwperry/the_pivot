class User::JobsController < ApplicationController
  before_action :sanitize_job_params, only: [:create]

  def new
    @job = Job.new
  end

  def create
    # new_job_params = job_params
    # new_job_params["duration_estimate"] = new_job_params["duration_estimate"].to_i
    byebug
    @job = current_user.jobs.new(job_params)
    if @job.save
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def show
    session[:forwarding_url] = request.url
    @user = User.find_by_slug(params[:user_slug])
    @job = JobPresenter.new(Job.find(params[:id]), view_context)
  end

  private

  def job_params
    params.require(:job).permit(:title,
                                :category_id,
                                :description,
                                :city,
                                :state,
                                :zipcode,
                                :bidding_close_date,
                                :must_complete_by_date,
                                :duration_estimate)
  end

  def sanitize_job_params
    params[:job][:duration_estimate] = params[:job][:duration_estimate].to_i
    params[:job][:close_hour] = params[:bid_close]["time(4i)"]
    params[:job][:close_minutes] = params[:bid_close]["time(5i)"]
    params[:job][:bidding_close_date] = DateTime.new(
  end
end
