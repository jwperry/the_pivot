require "test_helper"

class UserViewsJobShowPageTest < ActionDispatch::IntegrationTest
  test "guest views job show page" do
    job = create(:job)
    lister = job.lister

    visit user_job_path(job.lister, job)

    refute page.has_css? "#accordion h3", text: "Place A Bid"
    assert page.has_link? "Log In To Place A Bid", login_path
    refute page.has_css? "#current-bids"

    assert page.has_link? "« Back to #{job.category.name}", category_path(name)

    verify_job_info(job)
    verify_lister_info(lister)
  end

  test "contractor views job show page" do
    contractor = create(:contractor)
    job = create(:job)
    lister = job.lister

    ApplicationController.any_instance.stubs(:current_user).returns(contractor)

    visit user_job_path(lister, job)

    assert page.has_css? "#accordion h3", text: "Place A Bid"
    refute page.has_link? "Log In To Place A Bid", login_path
    refute page.has_css? "#current-bids"

    assert page.has_link? "« Back to #{job.category.name}", category_path(name)

    verify_job_info(job)
    verify_lister_info(lister)
  end

  test "lister views job show page for a job they did not list" do
    skip
  end

  test "lister views job show page for their own job" do
    bid = create(:bid)
    bidder = bid.user
    job = bid.job
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
      assert page.has_link? "Accept"
    end
  end

  def verify_job_info(job)
    within "#job-info" do
      assert page.has_content? job.title
      assert page.has_content? job.description
      assert page.has_content? job.duration_estimate
      assert page.has_content? "Bid Range: $#{job.lowest_bid} - $#{job.highest_bid}"

      if job.total_bids == 1
        assert page.has_content? "#{job.total_bids} bid"
      else
        assert page.has_content? "#{job.total_bids} bids"
      end

      assert page.has_content? "Must Be Completed By: #{job.complete_by_date}"
      assert page.has_content? "Bidding Ends: #{job.bidding_closes_on}"
      assert page.has_content? job.location
      assert page.has_css? "#google-map"
    end
  end

  def verify_lister_info(lister)
    within "#lister-info" do
      assert page.has_link? lister.full_name, user_path(lister)
      assert page.has_content? lister.rating
      assert page.has_css?("img[src*='#{lister.file_upload_file_name}']")

      if lister.number_of_active_jobs == 1
        assert page.has_content? "1 Active Job"
      else
        assert page.has_content? "#{lister.number_of_active_jobs} Active Jobs"
      end

      if lister.number_of_completed_jobs == 1
        assert page.has_content? "1 Completed Job"
      else
        assert page.has_content? "#{lister.number_of_completed_jobs} Completed Jobs"
      end

      assert page.has_content? "Active Since #{lister.account_created_date}"
    end
  end
end
