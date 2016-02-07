require "test_helper"

class ListerViewsDashboardTest < ActionDispatch::IntegrationTest
  test "lister views dashboard with bids and listings" do
    lister = create(:lister)
    job_lister_bid_on = create(:job)
    bid1 = create(:bid, job_id: job_lister_bid_on.id, user_id: lister.id)
    job_from_lister = create(:job, user_id: lister.id)
    completed_job = create(:job, status: "completed")

    job_with_comments = create(:job, status: "completed")
    comment = create(:comment, user_id: lister.id, job_id: job_with_comments.id)

    ApplicationController.any_instance.stubs(:current_user).returns(lister)
    mail_link = "mailto:#{lister.email_address}"

    visit dashboard_path

    within(".user-dashboard-info") do
      assert page.has_css?("img[src*='#{lister.file_upload_file_name}']")
      assert page.has_content?(lister.first_name)
      assert page.has_content?(lister.last_name)
      assert page.has_link?(lister.email_address, href: mail_link)
      assert page.has_content?(lister.street_address)
      assert page.has_content?(lister.city)
      assert page.has_content?(lister.state)
      assert page.has_content?(lister.zipcode)
      assert page.has_content?(lister.bio)
    end
    within(".links") do
      assert page.has_link?("Create Job")
      assert page.has_link?("Public Profile")
      assert page.has_link?("Edit Profile")
    end

    within(".tabs") do
      assert page.has_content?("My Listings")
      assert page.has_content?("My Bids")
    end


    within(".bid-#{bid1.id}") do
      assert page.has_link?(job_lister_bid_on.id, href: user_job_path(job_lister_bid_on.lister, job_lister_bid_on))
      assert page.has_link?(job_lister_bid_on.title, href: user_job_path(job_lister_bid_on.lister, job_lister_bid_on))
      assert page.has_content?(bid1.status)
      assert page.has_content?(job_lister_bid_on.bidding_close_date)
      assert page.has_content?(bid1.price)
    end

    bid_statuses = %w(all accepted pending rejected)

    within("#my-bids .filter") do
      assert page.has_select?("bid_status", options: bid_statuses)
    end

    click_on "My Listings"

    job_statuses = ["all",
                    "bidding open",
                    "bidding closed",
                    "in progress",
                    "completed",
                    "cancelled"]

    within("#my-listings .filter") do
      assert page.has_select?("job_status", options: job_statuses)
    end
    byebug
    within(".listing-#{job_from_lister.id}") do
      assert page.has_link?(job_from_lister.id, href: user_job_path(job_from_lister.lister, job_from_lister))
      assert page.has_link?(job_from_lister.title, href: user_job_path(job_from_lister.lister, job_from_lister))
      assert page.has_content?(job_from_lister.status)
      assert page.has_content?(job_from_lister.bidding_close_date)
      assert page.has_content?(job_from_lister.total_bids)
      assert page.has_content?(job_from_lister.bid_price_range)
      # assert page.has_link?("Cancel", href: user_job_path(job_from_lister.lister, job_from_lister))
    end

  end
end