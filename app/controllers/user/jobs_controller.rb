class User::JobsController < ApplicationController
  before_action :sanitize_job_params, only: [:create]
  before_action :require_platform_admin, only: [:destroy]
  before_action :sanitize_status_params, only: [:update]

  def new
    @job = Job.new
  end

  def create
    if current_contractor?
      flash[:error] = "Upgrade to a lister account to create jobs."
      redirect_to dashboard_path(current_user)
    else
      @job = current_user.jobs.new(job_params)
      if @job.save
        redirect_to user_job_path(current_user, @job)
      else
        flash.now[:error] = "New job creation failed."
        render :new
      end
    end
  end

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

    if update_status_params[:status]
      @job.update_attributes(update_status_params)

      if @job.completed?
        NotificationMailer.feedback_prompt(@job)
        redirect_to new_user_job_comment_path(current_user, @job)
      else
        redirect_to dashboard_path
      end
    end
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
    params[:job][:duration_estimate] = params[:job][:duration_estimate].to_i
  end

  def construct_bidding_close_date
    bid_close_date = params[:job][:bidding_close_date]
    param_hour = params[:bid_close]["time(4i)"]
    minute = params[:bid_close]["time(5i)"]

    DateTime.strptime("#{bid_close_date} #{param_hour}:#{minute}",
                      "%Y-%m-%d %k:%M")
  end

  def construct_must_complete_by_date
    complete_by_date = params[:job][:must_complete_by_date]
    DateTime.strptime("#{complete_by_date}", "%Y-%m-%d")
  end

  def require_platform_admin
    render file: "public/404" unless current_platform_admin?
  end

  def update_status_params
    params.permit(:status)
  end

  def sanitize_status_params
    params[:status] = params[:status].to_i
  end
end
