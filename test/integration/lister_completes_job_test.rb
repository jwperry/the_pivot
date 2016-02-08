require "test_helper"

class ListerCompletesJobTest < ActionDispatch::IntegrationTest
  test "lister completes bidding closed job" do
    lister = create(:lister)
    job = create(:job, user_id: lister.id, status: "in_progress")
    ApplicationController.any_instance.stubs(:current_user).returns(lister)

    visit dashboard_path
    click_on "My Listings"

    within(".listing-#{job.id}") do
      click_on "Complete"
    end

    job.reload

    assert_equal "completed", job.status
    assert_equal new_user_job_comment_path(job.user, job), current_path
  end
end