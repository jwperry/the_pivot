require "test_helper"

class JobListerAcceptsBidTest < ActionDispatch::IntegrationTest
  test "job lister can accept a bid once bidding is closed" do
    job = create(:job)
    bids = create_list(:bid, 3, job_id: job.id)
    job.bidding_closed!
    lister = job.lister

    bids.each do |bid|
      assert bid.pending?
    end

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
        refute page.has_css? "a", "Accept"
      end

      within "tbody tr:nth-child(2)" do
        assert page.has_css? "td", "Rejected"
        refute page.has_css? "a", "Accept"
      end

      within "tbody tr:nth-child(3)" do
        assert page.has_css? "td", "Rejected"
        refute page.has_css? "a", "Accept"
      end
    end
  end
end
