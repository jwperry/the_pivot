require "test_helper"

class BidTest < ActiveSupport::TestCase
  should validate_presence_of(:user_id)
  should validate_presence_of(:job_id)
  should validate_presence_of(:price)
  should validate_presence_of(:duration_estimate)
  should validate_presence_of(:details)
  should validate_presence_of(:status)

  test "contractor can bid on a job" do
    bid = create(:bid)

    assert bid.user.contractor?
  end

  test "job lister can bid on a job" do
    bid = create(:bid_placed_by_job_lister)

    assert bid.valid?
  end

  test "platform admin can bid on a job" do
    bid = create(:bid_placed_by_platform_admin)

    assert bid.valid?
  end

  test "bid details are a maximum of 400 characters" do
    bid = create(:bid)

    bid.update_attribute(:details, Faker::Lorem.characters(400))
    assert bid.valid?

    bid.update_attribute(:details, Faker::Lorem.characters(401))
    refute bid.valid?
  end

  test "bid details are a minimum of 35 characters" do
    bid = create(:bid)

    bid.update_attribute(:details, Faker::Lorem.characters(35))
    assert bid.valid?

    bid.update_attribute(:details, Faker::Lorem.characters(34))
    refute bid.valid?
  end

  test "price must be a positive number" do
    bid = create(:bid)

    bid.update_attribute(:price, 1)
    assert bid.valid?

    bid.update_attribute(:price, 1.5)
    refute bid.valid?

    bid.update_attribute(:price, 0)
    refute bid.valid?

    bid.update_attribute(:price, -1)
    refute bid.valid?

    bid.update_attribute(:price, "fff")
    refute bid.valid?

    bid.update_attribute(:price, "$123")
    refute bid.valid?

    bid.update_attribute(:price, "160,000")
    refute bid.valid?
  end

  test "duration estimate (in days) must be a positive number" do
    bid = create(:bid)

    bid.update_attribute(:duration_estimate, 1)
    assert bid.valid?

    bid.update_attribute(:duration_estimate, 1.5)
    refute bid.valid?

    bid.update_attribute(:duration_estimate, 0)
    refute bid.valid?

    bid.update_attribute(:duration_estimate, -1)
    refute bid.valid?

    bid.update_attribute(:duration_estimate, "fff")
    refute bid.valid?

    bid.update_attribute(:duration_estimate, "$123")
    refute bid.valid?

    bid.update_attribute(:duration_estimate, "160,000")
    refute bid.valid?
  end
end
