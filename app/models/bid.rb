class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :job

  validates :user_id, presence: true
  validates :job_id, presence: true
  validates :price, presence: true,
                    numericality: { only_integer: true,
                                    greater_than: 0 }
  validates :duration_estimate, presence: true,
                                numericality: { only_integer: true,
                                                greater_than: 0 }
  validates :details, presence: true,
                      length: { in: 35..400 }
  validates :status, presence: true

  enum status: %w(pending accepted rejected)

  scope :accepted_bid, -> { where(status: 1) }
end
