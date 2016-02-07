class User::BidsController < ApplicationController
  def create
    bid = current_user.bids.new(bid_params)

    if bid.save
      flash[:success] = "Bid Placed"
      redirect_to request.referrer
    else
    end
  end

  def update
    bid = Bid.find(params[:id])

    if bid.update_attributes(bid_params)
      flash[:success] = "Bid Updated"
      redirect_to request.referrer
    else
    end
  end

  private

  def bid_params
    params.require(:bid).permit(:price,
                                :duration_estimate,
                                :details).merge(job_id: params[:job_id])
  end
end
