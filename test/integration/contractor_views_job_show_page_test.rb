require "test_helper"

class ContractorViewsJobShowPageTest < ActionDispatch::IntegrationTest
  test "contractor views job show page while bidding is open" do
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

  test "contractor views job show page while bidding is closed" do
    contractor = create(:contractor)
    job = create(:job)
    job.bidding_closed!
    lister = job.lister

    ApplicationController.any_instance.stubs(:current_user).returns(contractor)

    visit user_job_path(lister, job)

    refute page.has_css? "#accordion h3", text: "Place A Bid"
    refute page.has_link? "Log In To Place A Bid", login_path
    refute page.has_css? "#current-bids"

    assert page.has_css? ".bidding-closed",
                         text: "Bidding Is Closed For This Job"
  end
end
