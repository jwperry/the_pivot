class BiddingWorker
  include Sidekiq::Worker

  def perform
    Job.update_bidding_status
  end
end
