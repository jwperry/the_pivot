class Job < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :bids
end
