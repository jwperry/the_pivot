require "test_helper"

class UserPlacesBidTest < ActionDispatch::IntegrationTest
  test "contractor places bid on a job and edits that bid" do
    contractor = create(:contractor)
    job = create(:job)
    lister = job.lister

    ApplicationController.any_instance.stubs(:current_user).returns(contractor)

    visit user_job_path(lister, job)

    within "#accordion" do
      assert page.has_content? contractor.full_name.capitalize
      fill_in :bid_price, with: 100
      fill_in :bid_duration_estimate, with: 10
      fill_in :bid_details, with: "You should hire me because I am the best"
      click_on "Submit Bid"
    end

    assert_equal 1, job.bids.count
    assert_equal 1, contractor.bids.count
    assert_equal user_job_path(lister, job), current_path

    assert page.has_css? "#accordion h3", text: "View My Bid"
    assert page.has_css? "h3.my-bid"
    assert page.has_content? "Bid Placed"

    within "#accordion" do
      assert page.has_content? contractor.full_name.capitalize
      assert page.has_field? "bid_price", with: "100"
      assert page.has_field? "bid_duration_estimate", with: "10"
      assert page.has_field? "bid_details", with: "You should hire me because I am the best"

      fill_in :bid_price, with: 105
      fill_in :bid_duration_estimate, with: 15
      fill_in :bid_details, with: "Puppies Kittens Meow Fluff Purr Meow"
      click_on "Update Bid"
    end

    assert page.has_content? "Bid Updated"

    bid = Bid.last
    assert_equal 105, bid.price
    assert_equal 15, bid.duration_estimate
    assert_equal "Puppies Kittens Meow Fluff Purr Meow", bid.details
  end

  test "contractor can delete an existing bid" do
    contractor = create(:contractor)
    job = create(:job)
    lister = job.lister
    bid = create(:bid, job_id: job.id, user_id: contractor.id)

    ApplicationController.any_instance.stubs(:current_user).returns(contractor)

    visit user_job_path(lister, job)

    within "#accordion" do
      assert page.has_content? contractor.full_name.capitalize
      assert page.has_field? "bid_price", with: bid.price
      assert page.has_field? "bid_duration_estimate", with: bid.duration_estimate
      assert page.has_field? "bid_details", with: bid.details

      click_on "Delete Bid"
    end

    assert_equal 0, job.bids.count
    assert_equal 0, contractor.bids.count

    assert page.has_css? "#accordion h3", text: "Place A Bid"
    refute page.has_css? "#accordion h3", text: "View My Bid"

    within "#accordion" do
      assert page.has_content? contractor.full_name.capitalize
      refute page.has_field? "bid_price", with: bid.price
      refute page.has_field? "bid_duration_estimate", with: bid.duration_estimate
      refute page.has_field? "bid_details", with: bid.details
    end
  end

  test "contractor cannot see other contractor's bids" do
    contractor_1 = create(:contractor)
    contractor_2 = create(:contractor)
    job = create(:job)
    lister = job.lister
    bid = create(:bid, job_id: job.id, user_id: contractor_1.id)

    ApplicationController.any_instance.stubs(:current_user).returns(contractor_2)

    visit user_job_path(lister, job)

    within "#accordion" do
      refute page.has_content? contractor_1.full_name.capitalize
      refute page.has_field? "bid_price", with: bid.price
      refute page.has_field? "bid_duration_estimate", with: bid.duration_estimate
      refute page.has_field? "bid_details", with: bid.details
    end

    refute page.has_css? "#current-bids"
  end
end
