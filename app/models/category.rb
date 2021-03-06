class Category < ActiveRecord::Base
  has_many :jobs

  validates :name, presence: true,
                   uniqueness: true

  before_create :generate_slug

  def to_param
    slug
  end

  def generate_slug
    self.slug = name.parameterize
  end

  def jobs_open_for_bidding
    jobs.bidding_open.order(created_at: :desc)
  end
end
