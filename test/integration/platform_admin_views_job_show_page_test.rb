require "test_helper"

class PlatformAdminViewsJobShowPageTest < ActionDispatch::IntegrationTest
  test "platform admin views job show page while bidding is open" do
    bid = create(:bid)
    bidder = bid.user
    job = bid.job
    job.bidding_open!
    lister = job.lister
    platform_admin = create(:platform_admin)

    ApplicationController.any_instance.stubs(:current_user).returns(platform_admin)

    visit user_job_path(lister, job)

    assert page.has_css? "#accordion h3", text: "Place A Bid"
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

    assert page.has_content? "Delete Job"
  end

  test "platform admin views job show page when bidding is closed" do
    bid = create(:bid)
    job = bid.job
    job.bidding_closed!
    lister = job.lister
    platform_admin = create(:platform_admin)

    ApplicationController.any_instance.stubs(:current_user).returns(platform_admin)

    visit user_job_path(lister, job)

    refute page.has_css? "#accordion h3", text: "Place A Bid"
    refute page.has_link? "Log In To Place A Bid", login_path
    assert page.has_css? ".bidding-closed",
                         text: "Bidding Is Closed For This Job"

    verify_job_info(job)
    verify_lister_info(lister)

    within "#current-bids" do
      assert page.has_link? bidder.full_name, user_path(bidder)
      assert page.has_content? bid.price
      assert page.has_content? bid.duration_estimate
      assert page.has_content? bid.details
      refute page.has_link? "Accept"
    end

    assert page.has_content? "Delete Job"
  end
end
