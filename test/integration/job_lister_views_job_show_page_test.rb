require "test_helper"

class JobListerViewsJobShowPageTest < ActionDispatch::IntegrationTest
  test "lister views job show page for a job they did not list" do
    bid = create(:bid)
    job = bid.job
    lister_1 = job.lister
    lister_2 = create(:lister)

    ApplicationController.any_instance.stubs(:current_user).returns(lister_2)

    visit user_job_path(lister_1, job)

    assert page.has_css? "#accordion h3", text: "Place A Bid"
    refute page.has_css? "#accordion h3", text: "View My Bid"
    refute page.has_link? "Log In To Place A Bid", login_path
    refute page.has_css? "#current-bids"
  end

  test "lister views job show page for their own job before bidding closes" do
    bid = create(:bid)
    bidder = bid.user
    job = bid.job
    job.bidding_open!
    lister = job.lister

    ApplicationController.any_instance.stubs(:current_user).returns(lister)

    visit user_job_path(lister, job)

    refute page.has_css? "#accordion h3", text: "Place A Bid"
    refute page.has_css? "#accordion h3", text: "View My Bid"
    refute page.has_link? "Log In To Place A Bid", login_path

    verify_job_info(job)
    verify_lister_info(lister)

    within "#current-bids" do
      assert page.has_link? bidder.full_name, user_path(bidder)
      assert page.has_content? bid.price
      assert page.has_content? bid.duration_estimate
      assert page.has_content? bid.details
      refute page.has_link? "Accept"
    end
  end

  test "lister views job show page for their own job after bidding closes" do
    bid = create(:bid)
    bidder = bid.user
    job = bid.job
    job.bidding_closed!
    lister = job.lister

    ApplicationController.any_instance.stubs(:current_user).returns(lister)

    visit user_job_path(lister, job)

    within "#current-bids" do
      assert page.has_link? bidder.full_name, user_path(bidder)
      assert page.has_content? bid.price
      assert page.has_content? bid.duration_estimate
      assert page.has_content? bid.details
      assert page.has_link? "Accept"
    end
  end
end
