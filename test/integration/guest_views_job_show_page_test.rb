require "test_helper"

class GuestViewsJobShowPageTest < ActionDispatch::IntegrationTest
  test "guest views job show page while bidding is open" do
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

  test "guest views job show page while bidding is closed" do
    job = create(:job)
    job.bidding_closed!

    visit user_job_path(job.lister, job)

    refute page.has_css? "#accordion h3", text: "Place A Bid"
    refute page.has_link? "Log In To Place A Bid", login_path
    refute page.has_css? "#current-bids"

    assert page.has_css? ".bidding-closed",
                         text: "Bidding Is Closed For This Job"
  end

  test "guest views job show page while job is in progress" do
    job = create(:job)
    job.in_progress!

    visit user_job_path(job.lister, job)

    refute page.has_css? "#accordion h3", text: "Place A Bid"
    refute page.has_link? "Log In To Place A Bid", login_path
    refute page.has_css? "#current-bids"

    assert page.has_css? ".job-in-progress",
                         text: "Job Is In Progress"
  end

  test "guest views job show page when job is completed" do
    job = create(:job)
    job.completed!

    visit user_job_path(job.lister, job)

    refute page.has_css? "#accordion h3", text: "Place A Bid"
    refute page.has_link? "Log In To Place A Bid", login_path
    refute page.has_css? "#current-bids"

    assert page.has_css? ".job-completed",
                         text: "Job Completed"
  end

  test "guest views job show page when job has been cancelled" do
    job = create(:job)
    job.cancelled!

    visit user_job_path(job.lister, job)

    refute page.has_css? "#accordion h3", text: "Place A Bid"
    refute page.has_link? "Log In To Place A Bid", login_path
    refute page.has_css? "#current-bids"

    assert page.has_css? ".job-cancelled",
                         text: "Job Cancelled"
  end
end
