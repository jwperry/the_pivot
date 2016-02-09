require "test_helper"

class ListerCompletesJobTest < ActionDispatch::IntegrationTest
  test "lister completes bidding closed job" do
    lister = create(:lister)
    job = create(:job, user_id: lister.id, status: "in_progress")
    job.bids << create(:bid, status: "accepted")
    ApplicationController.any_instance.stubs(:current_user).returns(lister)

    visit dashboard_path
    click_on "My Listings"

    within(".listing-#{job.id}") do
      click_on "Complete"
    end

    job.reload

    assert_equal "completed", job.status
    assert_equal new_user_job_comment_path(job.user, job), current_path

    text = "You were the most amazing" \
           "contractor I ever ever ever!!!"

    select "4", from: "comment_rating"
    fill_in "comment_text", with: text

    click_on "Leave Comment"

    comment = job.comments.last

    assert_equal dashboard_path, current_path
    assert_equal text, comment.text
    assert_equal 4, comment.rating
  end
end
