class Job < ActiveRecord::Base
  before_save :check_user_type

  belongs_to :category
  belongs_to :user
  has_many :bids, dependent: :destroy
  has_many :comments

  enum status: %w(bidding_open bidding_closed in_progress completed cancelled)
  enum duration_estimate: %w(short medium long event)

  scope :completed, -> { where(status: 3) }
  scope :in_progress, -> { where(status: 2) }
  scope :bid_selected, -> { where(status: [2, 3]) }
  scope :bidding_open, -> { where(status: 0) }

  validates :title,                 presence: true
  validates :category_id,           presence: true
  validates :user_id,               presence: true
  validates :status,                presence: true
  validates :city,                  presence: true
  validates :state,                 presence: true
  validates :zipcode,               presence: true
  validates :bidding_close_date,    presence: true
  validates :must_complete_by_date, presence: true
  validates :duration_estimate,     presence: true
  validates :description,           presence: true,
                                    length: { in: 50..600 }

  validate :bidding_close_date_cannot_be_in_the_past
  validate :must_complete_by_date_cannot_be_in_the_past
  validate :must_complete_by_date_is_after_bidding_close_date

  def bidding_close_date_cannot_be_in_the_past
    errors.add(:bidding_close_date, "can't be in the past") if
      !bidding_close_date.blank? && bidding_close_date < Date.today
  end

  def must_complete_by_date_cannot_be_in_the_past
    errors.add(:must_complete_by_date, "can't be in the past") if
      !must_complete_by_date.blank? && must_complete_by_date < Date.today
  end

  def must_complete_by_date_is_after_bidding_close_date
    if !must_complete_by_date.blank? &&
       !bidding_close_date.blank?    &&
       must_complete_by_date < bidding_close_date
      errors.add(:must_complete_by_date, "can't be before bidding close date")
    end
  end

  def self.update_bidding_status
    where(status: 0).each do |job|
      if job.bidding_close_date.past?
        job.bidding_closed!
        puts "Updated status of job: #{job.title}"
      end
    end
  end

  def lister
    user
  end

  def total_bids
    bids.count
  end

  def location
    "#{city}, #{state}"
  end

  def lowest_bid
    bids.minimum(:price)
  end

  def highest_bid
    bids.maximum(:price)
  end

  def bid_price_range
    "$#{lowest_bid} - $#{highest_bid}"
  end

  def bidding_closes_on
    bidding_close_date.utc.strftime("%b %e, %Y at %l:%M%P")
  end

  def complete_by_date
    must_complete_by_date.utc.strftime("%b %e, %Y")
  end

  def selected_bid
    bids.where(status: 1).first
  end

  def pending_bids
    bids.where(status: 0)
  end

  def bids_still_pending?
    pending_bids.any?
  end

  def bids_include_user(id)
    bids.pluck(:user_id).include?(id)
  end

  def my_bid(id)
    bids.find_by(user_id: id)
  end

  def contractor_for_selected_bid
    selected_bid.user
  end

  def feedback_required_from_contractor
    comments.count == 1
  end

  private

  def check_user_type
    User.find(user_id).lister? || User.find(user_id).platform_admin?
  end
end
