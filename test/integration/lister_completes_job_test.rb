require "test_helper"

class ListerCompletesJobTest < ActionDispatch::IntegrationTest
  test "lister completes bidding closed job" do
    lister = create(:lister)
    job = create(:job, user_id: lister.id, status: "in_progress")
    job.bids << create(:bid, status: "accepted")

    ApplicationController.any_instance.stubs(:current_user).returns(lister)

    visit dashboard_path
    click_on "My Listings"

    within("#my-listings tbody tr:nth-child(1)") do
      click_on "Complete"
    end

    job.reload

    assert_equal "completed", job.status
    assert_equal new_user_job_comment_path(lister, job), current_path

    text = "You were the most amazing" \
           "contractor I ever ever ever worked with!!!"

    select "4", from: "comment_rating"
    fill_in "comment_text", with: text

    click_on "Leave Comment"

    assert_equal dashboard_path, current_path

    comment = job.comments.last
    assert_equal text, comment.text
    assert_equal 4, comment.rating
  end

  test "contractor is prompted for feedback" do
    lister = create(:lister)
    job = create(:job, user_id: lister.id, status: "completed")
    bid = create(:bid, status: "accepted")
    contractor = bid.user
    job.bids << bid
    job.comments << create(:comment, user_id: lister.id,
                                     recipient_id: contractor.id)

    ApplicationController.any_instance.stubs(:current_user).returns(contractor)

    visit dashboard_path

    assert page.has_content? "Feedback Required"
    click_on "Leave Feedback"

    assert_equal new_user_job_comment_path(lister, job), current_path

    text = "You were the most amazing" \
           "lister I ever ever ever worked with!!!"

    select "4", from: "comment_rating"
    fill_in "comment_text", with: text
    click_on "Leave Comment"

    assert_equal dashboard_path, current_path
    refute page.has_content? "Feedback Required"

    comment = job.comments.last
    assert_equal text, comment.text
    assert_equal 4, comment.rating
  end
end
