class User::JobsController < ApplicationController
  before_action :sanitize_job_params, only: [:create]

  def new
    @job = Job.new
  end

  def create
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
    params[:job][:bidding_close_date] = construct_bidding_close_date
    params[:job][:must_complete_by_date] = construct_must_complete_by_date
  end

  def construct_bidding_close_date
    bid_close_date = params[:job][:bidding_close_date]
    param_hour = params[:bid_close]["time(4i)"]
    hour, am_pm = Time.parse("#{param_hour}").strftime("%l %P").split(" ")
    minute = params[:bid_close]["time(5i)"]
    DateTime.strptime("#{bid_close_date} #{hour}:#{minute} #{am_pm}", "%m/%d/%Y %I:%M %P")
  end

  def construct_must_complete_by_date
    complete_by_date = params[:job][:must_complete_by_date]
    DateTime.strptime("#{complete_by_date}", "%m/%d/%Y")
  end  
end
