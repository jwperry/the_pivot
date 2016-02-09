class User::BidsController < ApplicationController
  before_action :set_bid, only: [:update, :destroy]

  def create
    bid = current_user.bids.new(bid_params)

    if bid.save
      flash[:success] = "Bid Placed"
    else
      flash[:error] = "Bid could not be placed"
    end

    redirect_to_job_show_page
  end

  def update
    if params[:status]
      update_bid_and_job_status
    else
      if @bid.update_attributes(bid_params)
        flash[:success] = "Bid Updated"
      else
        flash[:error] = "Bid could not be updated"
      end
    end

    redirect_to_job_show_page
  end

  def destroy
    @bid.destroy if current_user_placed_bid
    redirect_to_job_show_page
  end

  private

  def bid_params
    params.require(:bid).permit(:price,
                                :duration_estimate,
                                :details).merge(job_id: params[:job_id])
  end

  def set_bid
    @bid = Bid.find(params[:id])
  end

  def redirect_to_job_show_page
    redirect_to user_job_path(params[:user_slug], params[:job_id])
  end

  def current_user_placed_bid
    current_user.id == @bid.user_id
  end

  def update_bid_and_job_status
    @bid.accepted!

    @bid.job.pending_bids.each(&:rejected!)

    @bid.job.in_progress!
    NotificationMailer.notify_bidders(@bid.job)
  end
end
