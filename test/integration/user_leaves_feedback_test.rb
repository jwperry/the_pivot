require "test_helper"

class UserLeavesFeedbackTest < ActionDispatch::IntegrationTest
  test "lister leaves feedback for contractor" do
    bid = create(:bid)
    job = bid.job
    job.completed!
    bid.accepted!
    lister = job.lister
    contractor = bid.user


  end
end
