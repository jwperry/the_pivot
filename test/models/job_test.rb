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

  test "bid price range" do
    job = create(:job)
    bid1 = create(:bid, price: 2, job_id: job.id)
    bid1 = create(:bid, price: 400, job_id: job.id)

    assert_equal "$2 - $400", job.bid_price_range
  end
end
