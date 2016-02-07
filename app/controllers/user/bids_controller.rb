class User::BidsController < ApplicationController
  before_action :set_bid, only: [:update, :destroy]

  def create
    bid = current_user.bids.new(bid_params)

    if bid.save
      flash[:success] = "Bid Placed"
      redirect_to request.referrer
    else
      flash[:error] = "Bid could not be placed"
      redirect_to request.referrer
    end
  end

  def update
    if params[:status]
      update_bid_and_job_status
      redirect_to request.referrer
    else
      if @bid.update_attributes(bid_params)
        flash[:success] = "Bid Updated"
        redirect_to request.referrer
      else
        flash[:error] = "Bid could not be updated"
        redirect_to request.referrer
      end
    end
  end

  def destroy
    @bid.destroy if current_user_placed_bid
    redirect_to request.referrer
  end

  private

  def bid_params
    params.require(:bid).permit(:price,
                                :duration_estimate,
                                :details,
                                :job_id).merge(job_id: params[:job_id])
  end

  def set_bid
    @bid = Bid.find(params[:id])
  end

  def current_user_placed_bid
    current_user.id == @bid.user_id
  end

  def update_bid_and_job_status
    @bid.accepted!

    @bid.job.pending_bids.each do |bid|
      bid.rejected!
    end

    @bid.job.in_progress!
  end
end
