

class BidTest < ActiveSupport::TestCase
  should validate_presence_of(:user_id)
  should validate_presence_of(:job_id)
  should validate_presence_of(:price)
  should validate_presence_of(:duration_estimate)
  should validate_presence_of(:details)
  should validate_presence_of(:status)

  
end

t.integer "user_id"
t.integer "job_id"
t.integer "price"
t.integer "duration_estimate"
t.text    "details"
t.integer "status",            default: 0
