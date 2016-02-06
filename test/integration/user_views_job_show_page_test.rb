require "test_helper"

class UserViewsJobShowPageTest < ActionDispatch::IntegrationTest
  test "guest views job show page" do
    job = create(:job)
    lister = job.lister

    visit user_job_path(job.lister, job)

    refute page.has_css? "#accordion h3", text: "Place A Bid"
    assert page.has_link? "Log In To Place A Bid", login_path

    assert page.has_link? "« Back to #{job.category.name}", category_path(name)

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
