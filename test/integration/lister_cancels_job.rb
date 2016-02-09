require "test_helper"

class ListerCancelsJobTest < ActionDispatch::IntegrationTest
  test "lister cancels bidding open job" do
    lister = create(:lister)
    open_bid_job = create(:job, user_id: lister.id)
    ApplicationController.any_instance.stubs(:current_user).returns(lister)

    visit dashboard_path
    click_on "My Listings"

    within(".listing-#{open_bid_job.id}") do
      click_on "Cancel"
    end

    open_bid_job.reload && lister.reload
    assert_equal dashboard_path, current_path
    assert_equal "cancelled", open_bid_job.status
    within(".listing-#{open_bid_job.id} .job-status") do
      assert page.has_content?("cancelled")
    end
  end

  test "lister cancels bidding closed job" do
    lister = create(:lister)
    closed_bid_job = create(:job, user_id: lister.id, status: "bidding_closed")
    ApplicationController.any_instance.stubs(:current_user).returns(lister)

    visit dashboard_path
    click_on "My Listings"

    within(".listing-#{closed_bid_job.id}") do
      click_on "Cancel"
    end

    closed_bid_job.reload && lister.reload
    assert_equal dashboard_path, current_path
    assert_equal "cancelled", closed_bid_job.status
    within(".listing-#{closed_bid_job.id} .job-status") do
      assert page.has_content?("cancelled")
    end
  end
end
