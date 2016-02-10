class User < ActiveRecord::Base
  before_create :generate_slug
  before_save :check_image_path
  has_secure_password

  has_many :bids
  has_many :jobs
  has_many :comments
  has_many :authorizations

  validates :username,       presence: true,
                             uniqueness: true
  validates :first_name,     presence: true
  validates :last_name,      presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email_address,  presence: true,
                             uniqueness: true,
                             format: { with: VALID_EMAIL_REGEX }
  validates :street_address, presence: true
  validates :city,           presence: true
  validates :state,          presence: true
  validates :zipcode,        presence: true
  validates :bio,            presence: true,
                             length: { in: 35..600 }

  DEFAULT_PHOTO = "http://t2.tagstat.com/im/people/silhouette_m_300.png"
  has_attached_file :file_upload,
                    styles: { medium: "300x300>", thumb: "100x100>" },
                    default_url: DEFAULT_PHOTO

  validates_attachment_content_type :file_upload,
                                    content_type: %r{\Aimage\/.*\Z}

  scope :listers, -> { where(role: 1) }
  scope :contractors, -> { where(role: 0) }

  enum role: %w(contractor lister platform_admin)

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{street_address} #{city}, #{state} #{zipcode}"
  end

  def to_param
    slug
  end

  def generate_slug
    self.slug = username.parameterize
  end

  def location
    "#{city}, #{state}"
  end

  def rating
    if !all_received_comments.empty?
      "#{all_received_comments.average(:rating).round(1)} / 5.0"
    else
      "No Rating Available"
    end
  end

  def number_of_active_jobs
    jobs.where(status: [0, 1, 2]).count
  end

  def number_of_completed_jobs
    jobs.where(status: 3).count
  end

  def account_created_date
    created_at.strftime("%B %Y")
  end

  def all_received_comments
    Comment.where(recipient_id: id)
  end

  def received_comments_for_completed_listings
    all_received_comments.select do |comment|
      comment.job.lister.id == id
    end
  end

  def received_comments_for_completed_jobs
    all_received_comments.select do |comment|
      comment.job.lister.id != id
    end
  end

  def has_bids?
    bids.any?
  end

  def has_jobs?
    jobs.any?
  end

  def only_one_picture
    errors.add(:base, "Please upload a picture OR enter an image path") if
    both_image_fields
  end

  def at_least_one_picture
    errors.add(:base, "You can only upload a picture OR enter an image path") if
    neither_image_fields
  end


  private

  def neither_image_fields
    image_path_is_empty_or_nil && file_upload_is_empty_or_nil
  end

  def both_image_fields
    image_path && file_upload
  end

  def image_path_is_empty_or_nil
    image_path.nil? || image_path.empty?
  end

  def file_upload_is_empty_or_nil
    file_upload.nil? || file_upload.empty?
  end
end
