class Job < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :bids

  enum status: %w(bidding_open bidding_closed in_progress completed cancelled)

  scope :completed, -> { where(status: 3) }
  scope :in_progress, -> { where(status: 2) }
  scope :bid_selected, -> { where(status: [2, 3]) }
end
