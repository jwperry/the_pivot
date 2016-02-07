require "test_helper"

class JobListerAcceptsBidTest < ActionDispatch::IntegrationTest
  test "job lister can accept a bid once bidding is closed" do
    job = create(:job)
    bids = create_list(:bid, 3, job_id: job.id)
    job.bidding_closed!
    lister = job.lister

    bids.each { |bid| assert bid.pending? }

    ApplicationController.any_instance.stubs(:current_user).returns(lister)

    visit user_job_path(lister, job)

    within "#current-bids" do
      within "tbody tr:nth-child(1)" do
        assert page.has_link? "Accept"
      end

      within "tbody tr:nth-child(2)" do
        assert page.has_link? "Accept"
      end

      within "tbody tr:nth-child(3)" do
        assert page.has_link? "Accept"
      end

      first(:link, "Accept").click

      within "tbody tr:nth-child(1)" do
        assert page.has_css? "td", "Accepted"
      end

      within "tbody tr:nth-child(2)" do
        assert page.has_css? "td", "Rejected"
      end

      within "tbody tr:nth-child(3)" do
        assert page.has_css? "td", "Rejected"
      end
    end

    assert job.bids[0].accepted?
    assert job.bids[1].rejected?
    assert job.bids[2].rejected?

    job.reload

    assert job.in_progress?
    assert page.has_content? "Job Is In Progress"
  end
end
