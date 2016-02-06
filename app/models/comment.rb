class Comment < ActiveRecord::Base
  before_save :verify_number_of_comments_on_job

  belongs_to :user
  belongs_to :job
  belongs_to :recipient,
             class_name: "User",
             foreign_key: :recipient_id

  SECOND_COMMENT_MESSAGE = "Cannot leave more than one comment per job".freeze
  validates :user_id, presence: true,
                      uniqueness: { scope: :job_id,
                                    message: SECOND_COMMENT_MESSAGE }
  validates :recipient_id, presence: true
  validates :text, presence: true,
                   length: { in: 50..600 }
  validates :rating, presence: true,
                     inclusion: { in: 0..5 },
                     numericality: { only_integer: true }
  validates :job_id, presence: true
  validate  :user_and_recipient_are_different_people
  validate  :less_than_two_comments_exist_for_job

  def user_and_recipient_are_different_people
    errors.add(:recipient_id, "can't give a comment to yourself") if
      !user_id.blank?      &&
      !recipient_id.blank? &&
      recipient_id == user_id
  end

  def less_than_two_comments_exist_for_job
    errors.add(:job_id, "two comments already exist for this job") if
      !job_id.blank? && Job.find(job_id).comments.count == 2
  end

  def associated_job_title
    job.title
  end

  def associated_job_duration
    job.duration_estimate
  end

  def accepted_bid_price
    job.selected_bid.price
  end

  def posted_at
    created_at.strftime("%b %e, %Y %l:%M%P")
  end

  private

  def verify_number_of_comments_on_job
    Job.find(job_id).comments.count < 2
  end
end
