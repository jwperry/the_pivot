class Job < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  validates :title, presence: true
  validates :category_id, presence: true
  validates :user_id, presence: true
  validates :status, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true
  validates :bidding_close_date, presence: true
  validates :must_complete_by_date, presence: true
  validates :duration_estimate, presence: true
end
