require "test_helper"

class UserLeavesFeedbackTest < ActionDispatch::IntegrationTest
  test "lister leaves feedback for contractor" do
    bid = create(:bid)
    job = bid.job
    job.completed!
    bid.accepted!
    lister = job.lister
    contractor = bid.user

    ApplicationController.any_instance.stubs(:current_user).returns(lister)

    visit new_user_job_comment_path(lister, job)

    select "4", from: "comment_rating"
    fill_in "comment_text", with: "You were the most amazing" \
                                  "contractor I ever ever ever!!!"

    click_on "Leave Comment"

    assert_equal dashboard_path, current_path

    visit user_path(contractor)

    comment = Comment.last

    within "#previous-jobs" do
      assert page.has_content? comment.text
      assert page.has_link? lister.full_name, user_path(lister)
      assert page.has_content? comment.rating
      assert page.has_content? comment.posted_at
      assert page.has_content? comment.accepted_bid_price
    end
  end

  test "contractor leaves feedback for lister" do
    bid = create(:bid)
    job = bid.job
    job.completed!
    bid.accepted!
    lister = job.lister
    contractor = bid.user

    ApplicationController.any_instance.stubs(:current_user).returns(contractor)

    visit new_user_job_comment_path(lister, job)

    select "4", from: "comment_rating"
    fill_in "comment_text", with: "You were the most amazing" \
                                  "lister I ever ever ever!!!"

    click_on "Leave Comment"

    assert_equal dashboard_path, current_path

    visit user_path(lister)

    comment = Comment.last

    within "#previous-listings" do
      assert page.has_content? comment.text
      assert page.has_link? contractor.full_name, user_path(contractor)
      assert page.has_content? comment.rating
      assert page.has_content? comment.posted_at
      assert page.has_content? comment.accepted_bid_price
    end
  end

  test "user cannot leave feedback for a project that is not theirs" do
    bid = create(:bid)
    job = bid.job
    job.completed!
    bid.accepted!
    lister = job.lister
    contractor = bid.user
    new_user = create(:contractor)

    ApplicationController.any_instance.stubs(:current_user).returns(new_user)

    visit new_user_job_comment_path(lister, job)

    assert page.has_content?("The page you were looking for doesn't exist.")
    refute page.has_content?(contractor.first_name)
    refute page.has_content?(contractor.last_name)
    refute page.has_content?(lister.first_name)
    refute page.has_content?(lister.last_name)
    refute page.has_content?(job.title)
  end

  test "a contractor cannot leave feedback for a job twice" do
    bid = create(:bid)
    job = bid.job
    job.completed!
    bid.accepted!
    lister = job.lister
    contractor = bid.user

    ApplicationController.any_instance.stubs(:current_user).returns(contractor)

    visit new_user_job_comment_path(lister, job)
    select "4", from: "comment_rating"
    fill_in "comment_text", with: "You were the most amazing" \
                                  "lister I ever ever ever!!!"
    click_on "Leave Comment"

    visit new_user_job_comment_path(lister, job)
    assert page.has_content?("The page you were looking for doesn't exist.")
    refute page.has_content?(lister.first_name)
    refute page.has_content?(lister.last_name)
    refute page.has_content?(job.title)
  end

  test "a lister cannot leave feedback for a job twice" do
    bid = create(:bid)
    job = bid.job
    job.completed!
    bid.accepted!
    lister = job.lister
    contractor = bid.user

    ApplicationController.any_instance.stubs(:current_user).returns(lister)

    visit new_user_job_comment_path(lister, job)
    select "4", from: "comment_rating"
    fill_in "comment_text", with: "You were the most amazing" \
                                  "lister I ever ever ever!!!"
    click_on "Leave Comment"

    visit new_user_job_comment_path(lister, job)
    assert page.has_content?("The page you were looking for doesn't exist.")
    refute page.has_content?(contractor.first_name)
    refute page.has_content?(contractor.last_name)
    refute page.has_content?(job.title)
  end
end
