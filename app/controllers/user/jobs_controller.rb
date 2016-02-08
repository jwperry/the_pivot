class User::JobsController < ApplicationController
  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
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
end
