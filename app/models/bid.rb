class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :job

  enum status: %w(pending accepted rejected)

  scope :accepted_bid, -> { where(status: 1) }
end
