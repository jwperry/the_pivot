class Category < ActiveRecord::Base
  has_many :items
  validates :name, presence: true,
                   uniqueness: true
  before_create :generate_slug
  has_many :jobs

  def to_param
    slug
  end

  def generate_slug
    self.slug = name.parameterize
  end
end
