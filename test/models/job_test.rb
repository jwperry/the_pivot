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
  end

  test ""
end

# Title is required
# Category ID is required
# Cannot be assigned to non-existent category
# Only a lister can be referenced with the user id
# Default status is 1 (is this correct?)
# City is required
# State is required
# Zipcode is required
# Bidding close date is in the future
# Must complete by date is in the future, and further than the bidding close date
# Duration estimate is required
