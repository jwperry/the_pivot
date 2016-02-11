require "test_helper"

class JobTest < ActiveSupport::TestCase
  should validate_presence_of(:title)
  should validate_presence_of(:category_id)
  should validate_presence_of(:user_id)
  should validate_presence_of(:status)
  should validate_presence_of(:city)
  should validate_presence_of(:state)
  should validate_presence_of(:zipcode)
  should validate_presence_of(:bidding_close_date)
  should validate_presence_of(:must_complete_by_date)
  should validate_presence_of(:duration_estimate)
  should validate_presence_of(:description)
  should validate_numericality_of(:zipcode)
  should validate_length_of(:zipcode).is_at_least(5)

  test "is valid with valid parameters" do
    job = create(:job)

    assert job.valid?
    assert job.user.lister?
    assert_equal 1, Job.count
  end

  test "job cannot belong to a contractor" do
    contractor = create(:contractor)
    category = create(:category)
    contractor.jobs.create(
      title: "Title",
      category_id: category.id,
      description: "Description",
      status: 1,
      city: "Denver",
      state: "CO",
      zipcode: 802_10,
      bidding_close_date: DateTime.new(2080, 2, 3),
      must_complete_by_date: DateTime.new(2081, 2, 3),
      duration_estimate: 0
    )

    assert_equal 0, contractor.jobs.count
  end

  test "job can belong to a platform admin" do
    job = create(:job_posted_by_platform_admin)
    platform_admin = job.user

    assert_equal 1, platform_admin.jobs.count
  end

  test "is invalid with bidding close date in the past" do
    lister = create(:lister)
    category = create(:category)
    job = Job.new(
      title: "Title",
      category_id: category.id,
      user_id: lister.id,
      description: "Description",
      status: 1,
      city: "Denver",
      state: "CO",
      zipcode: 802_10,
      bidding_close_date: DateTime.new(2001, 2, 3),
      must_complete_by_date: DateTime.new(2081, 2, 3),
      duration_estimate: 0
    )

    refute job.valid?
  end

  test "is invalid with must complete by date in the past" do
    lister = create(:lister)
    category = create(:category)
    job = Job.new(
      title: "Title",
      category_id: category.id,
      user_id: lister.id,
      description: "Description",
      status: 1,
      city: "Denver",
      state: "CO",
      zipcode: 802_10,
      bidding_close_date: DateTime.new(2080, 2, 3),
      must_complete_by_date: DateTime.new(2001, 2, 3),
      duration_estimate: 0
    )

    refute job.valid?
  end

  test "is invalid with must complete by date before bidding close date" do
    lister = create(:lister)
    category = create(:category)
    job = Job.new(
      title: "Title",
      category_id: category.id,
      user_id: lister.id,
      description: "Description",
      status: 1,
      city: "Denver",
      state: "CO",
      zipcode: 802_10,
      bidding_close_date: DateTime.new(2080, 12, 3),
      must_complete_by_date: DateTime.new(2080, 1, 1),
      duration_estimate: 0
    )

    refute job.valid?
  end

  test "is invalid with description less than 50 characters" do
    job = create(:job)

    job.update_attribute(:description, Faker::Lorem.characters(50))
    assert job.valid?

    job.update_attribute(:description, Faker::Lorem.characters(49))
    refute job.valid?
  end

  test "is invalid with description greater than 600 characters" do
    job = create(:job)

    job.update_attribute(:description, Faker::Lorem.characters(600))
    assert job.valid?

    job.update_attribute(:description, Faker::Lorem.characters(601))
    refute job.valid?
  end

  test "bid price range" do
    job = create(:job)
    create(:bid, price: 2, job_id: job.id)
    create(:bid, price: 400, job_id: job.id)

    assert_equal "Bid Range: $2 - $400", job.bid_price_range
  end

  test "updates bidding status for jobs in the past" do
    bidding_expired_job = create(:job,
                                 status: 0,
                                 bidding_close_date: Time.now + 1)
    bidding_not_expired_job = create(:job,
                                     status: 0,
                                     bidding_close_date: Time.now + 45)

    assert bidding_expired_job.bidding_open?
    assert bidding_not_expired_job.bidding_open?

    sleep(2)

    Job.update_bidding_status

    bidding_expired_job.reload
    bidding_not_expired_job.reload

    refute bidding_expired_job.bidding_open?
    assert bidding_expired_job.bidding_closed?
    assert bidding_not_expired_job.bidding_open?
  end
end
