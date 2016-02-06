require "test_helper"

class CommentTest < ActiveSupport::TestCase
  should validate_presence_of(:user_id)
  should validate_presence_of(:recipient_id)
  should validate_presence_of(:text)
  should validate_presence_of(:rating)
  should validate_presence_of(:job_id)

  test "is invalid if user and recipient are the same person" do
    comment = create(:comment)
    comment.update_attribute(:recipient_id, comment.user.id)

    refute comment.valid?
  end

  test "single job cannot be updated to have more than two comments" do
    comment_1 = create(:comment)
    job = comment_1.job
    comment_2 = create(:comment)
    comment_3 = create(:comment)

    comment_2.update_attribute(:job_id, job.id)
    comment_3.update_attribute(:job_id, job.id)

    assert_equal 2, job.comments.count
  end

  test "single job cannot have three comments created for it" do
    job = create(:job)
    contractor = create(:contractor)
    text = "Lorem ipsum dolor sit amet, ipsum amet sed mattis ligula facilisis"
    comment_1 = job.comments.new(
      user_id: job.user.id,
      recipient_id: contractor.id,
      text: text,
      rating: 2
    )

    assert comment_1.valid?
    comment_1.save
    assert_equal 1, job.comments.count

    comment_2 = job.comments.new(
      user_id: contractor.id,
      recipient_id: job.user.id,
      text: text,
      rating: 3
    )

    assert comment_2.valid?
    comment_2.save
    assert_equal 2, job.comments.count

    comment_3 = job.comments.new(
      user_id: contractor.id,
      recipient_id: job.user.id,
      text: text,
      rating: 3
    )

    refute comment_3.valid?
    comment_3.save
    assert_equal 2, job.comments.count
  end

  test "is invalid with text less than 50 characters" do
    comment = create(:comment)

    comment.update_attribute(:text, Faker::Lorem.characters(50))
    assert comment.valid?

    comment.update_attribute(:text, Faker::Lorem.characters(49))
    refute comment.valid?
  end

  test "is invalid with text greater than 600 characters" do
    comment = create(:comment)

    comment.update_attribute(:text, Faker::Lorem.characters(600))
    assert comment.valid?

    comment.update_attribute(:text, Faker::Lorem.characters(601))
    refute comment.valid?
  end

  test "is invalid if rating is less than 0" do
    comment = create(:comment)

    comment.update_attribute(:rating, 0)
    assert comment.valid?

    comment.update_attribute(:rating, -1)
    refute comment.valid?
  end

  test "is invalid if rating is greater than 5" do
    comment = create(:comment)

    comment.update_attribute(:rating, 5)
    assert comment.valid?

    comment.update_attribute(:rating, 6)
    refute comment.valid?
  end

  test "is invalid of rating is not an integer" do
    comment = create(:comment)

    comment.update_attribute(:rating, 2.5)
    refute comment.valid?

    comment.update_attribute(:rating, "1.2")
    refute comment.valid?

    comment.update_attribute(:rating, "fff")
    refute comment.valid?

    comment.update_attribute(:rating, true)
    refute comment.valid?

    comment.update_attribute(:rating, [2])
    refute comment.valid?
  end
end
