require "test_helper"

class PlatformAdminDeletesJobTest < ActionDispatch::IntegrationTest
  test "job and all related bids are deleted" do
    bid = create(:bid)
    job = bid.job
    job.bidding_open!
    lister = job.lister
    platform_admin = create(:platform_admin)

    ApplicationController.any_instance.stubs(:current_user).returns(platform_admin)

    visit user_job_path(lister, job)

    click_on "Delete Job"

    assert_equal category_path(job.category), current_path

    assert page.has_content?(job.category.name)
    refute page.has_content?(job.title)

    assert_equal 0, Bid.count
    assert_equal 0, Job.count
    assert_equal 0, lister.jobs.count
  end
end
