require "test_helper"

class ContractorViewsDashboardTest < ActionDispatch::IntegrationTest
  test "contractor views dashboard with bids" do
    contractor = create(:contractor)
    job1 = create(:job)
    bid1 = create(:bid, job_id: job1.id, user_id: contractor.id)
    ApplicationController.any_instance.stubs(:current_user).returns(contractor)
    mail_link = "mailto:#{contractor.email_address}"

    visit dashboard_path

    within(".user-dashboard-info") do
      assert page.has_css?("img[src*='#{contractor.file_upload_file_name}']")
      assert page.has_content?(contractor.first_name)
      assert page.has_content?(contractor.last_name)
      assert page.has_link?(contractor.email_address, href: mail_link)
      assert page.has_content?(contractor.street_address)
      assert page.has_content?(contractor.city)
      assert page.has_content?(contractor.state)
      assert page.has_content?(contractor.zipcode)
      assert page.has_content?(contractor.bio)
    end
    within(".links") do
      refute page.has_link?("Create Job")
      assert page.has_link?("Public Profile")
      assert page.has_link?("Edit Profile")
    end

    within(".tabs") do
      refute page.has_content?("My Listings")
      assert page.has_content?("My Bids")
    end

    within(".bid-#{bid1.id}") do
      assert page.has_link?(job1.id, href: user_job_path(job1.lister, job1))
      assert page.has_link?(job1.title, href: user_job_path(job1.lister, job1))
      assert page.has_content?(bid1.status)
      assert page.has_content?(job1.bidding_close_date)
      assert page.has_content?(bid1.price)
    end

    bid_statuses = %w(all accepted pending rejected)

    within("#my-bids .filter") do
      assert page.has_select?("bid_status", options: bid_statuses)
    end
  end

  test "contractor views dashboard with no bids" do
    contractor = create(:contractor)
    ApplicationController.any_instance.stubs(:current_user).returns(contractor)

    visit dashboard_path

    within(".no-bids") do
      assert page.has_content?("You have not bid on any jobs yet.")
    end
  end
end
