require "test_helper"

class ListerViewsDashboardTest < ActionDispatch::IntegrationTest
  test "lister views dashboard with bids and listings" do
    lister = create(:lister)
    job_lister_bid_on = create(:job)
    bid1 = create(:bid, job_id: job_lister_bid_on.id, user_id: lister.id)
    open_bid_job = create(:job, user_id: lister.id)
    closed_bid_job = create(:job,
                            user_id: lister.id,
                            status: "bidding_closed",
                            bidding_close_date: Time.now.to_datetime)
    accepted_bid1 = create(:bid, status: 1)
    in_progress_job = create(:job,
                             user_id: lister.id,
                             status: "in_progress")
    in_progress_job.bids << accepted_bid1
    accepted_bid2 = create(:bid, status: 1)
    completed_job = create(:job, user_id: lister.id, status: "completed")
    completed_job.bids << accepted_bid2
    cancelled_job = create(:job, user_id: lister.id, status: "cancelled")

    job_with_comments = create(:job, status: "completed")
    create(:comment, user_id: lister.id, job_id: job_with_comments.id)

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

    within("#my-bids tbody tr:nth-child(1)") do
      assert page.has_link?(job_lister_bid_on.id,
                            href: user_job_path(job_lister_bid_on.lister,
                                                job_lister_bid_on))
      assert page.has_link?(job_lister_bid_on.title,
                            href: user_job_path(job_lister_bid_on.lister,
                                                job_lister_bid_on))
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

    within("#my-listings tbody tr:nth-child(1)") do
      assert page.has_link?(open_bid_job.id,
                            href: user_job_path(open_bid_job.lister,
                                                open_bid_job))
      assert page.has_link?(open_bid_job.title,
                            href: user_job_path(open_bid_job.lister,
                                                open_bid_job))
      assert page.has_content?("bidding open")
      assert page.has_content?(open_bid_job.bidding_close_date)
      assert page.has_content?(open_bid_job.total_bids)
      assert page.has_content?(open_bid_job.bid_price_range)
      assert page.has_link?("Cancel",
                            href: user_job_path(lister,
                                                open_bid_job,
                                                status: 4))
      assert_equal "", find(".contractor").text
    end

    within("#my-listings tbody tr:nth-child(2)") do
      assert page.has_link?(closed_bid_job.id,
                            href: user_job_path(closed_bid_job.lister,
                                                closed_bid_job))
      assert page.has_link?(closed_bid_job.title,
                            href: user_job_path(closed_bid_job.lister,
                                                closed_bid_job))
      assert page.has_content?("bidding closed")
      assert page.has_content?(closed_bid_job.bidding_close_date)
      assert page.has_content?(closed_bid_job.total_bids)
      assert page.has_content?(closed_bid_job.bid_price_range)
      assert page.has_link?("Choose Bid",
                            href: user_job_path(lister,
                                                closed_bid_job))
      assert page.has_link?("Cancel",
                            href: user_job_path(lister,
                                                closed_bid_job,
                                                status: 4))
      assert_equal "", find(".contractor").text
    end

    within("#my-listings tbody tr:nth-child(3)") do
      assert page.has_link?(in_progress_job.id,
                            href: user_job_path(in_progress_job.lister,
                                                in_progress_job))
      assert page.has_link?(in_progress_job.title,
                            href: user_job_path(in_progress_job.lister,
                                                in_progress_job))
      assert page.has_content?("in progress")
      assert page.has_content?(in_progress_job.bidding_close_date)
      assert page.has_content?(in_progress_job.total_bids)
      assert page.has_content?(in_progress_job.bid_price_range)
      assert page.has_link?("Complete",
                            href: user_job_path(lister,
                                                in_progress_job,
                                                status: 3))
      assert page.has_content?(accepted_bid1.user.full_name)
    end

    within("#my-listings tbody tr:nth-child(4)") do
      assert page.has_link?(completed_job.id,
                            href: user_job_path(completed_job.lister,
                                                completed_job))
      assert page.has_link?(completed_job.title,
                            href: user_job_path(completed_job.lister,
                                                completed_job))
      assert page.has_content?("completed")
      assert page.has_content?(completed_job.bidding_close_date)
      assert page.has_content?(completed_job.total_bids)
      assert page.has_content?(completed_job.bid_price_range)
      assert page.has_content?(accepted_bid2.user.full_name)
    end

    within("#my-listings tbody tr:nth-child(5)") do
      assert page.has_link?(cancelled_job.id,
                            href: user_job_path(cancelled_job.lister,
                                                cancelled_job))
      assert page.has_link?(cancelled_job.title,
                            href: user_job_path(cancelled_job.lister,
                                                cancelled_job))
      assert page.has_content?("cancelled")
      assert page.has_content?(cancelled_job.bidding_close_date)
      assert page.has_content?(cancelled_job.total_bids)
      assert page.has_content?(cancelled_job.bid_price_range)
      assert_equal "", find(".contractor").text
    end
  end
end
