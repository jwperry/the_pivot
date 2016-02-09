require "test_helper"

class PlatformAdminViewCategoryShowTest < ActionDispatch::IntegrationTest
  test "platform admin can view category show page" do
    job = create(:job)
    platform_admin = create(:platform_admin)

    ApplicationController.any_instance.stubs(:current_user).returns(platform_admin)

    visit category_path(job.category.name)

    assert page.has_content?(job.category.name)
    assert page.has_content?(job.title)
    assert page.has_content?(job.description)
    assert page.has_content?(job.duration_estimate)
    assert page.has_content?(job.user.full_name)
    assert page.has_content?(job.user.file_upload_file_name)
    assert page.has_content?(job.bids.count)
    assert page.has_content?(job.city)
    assert page.has_content?(job.state)
    assert page.has_content?(job.lowest_bid)
    assert page.has_content?(job.highest_bid)
    assert page.has_content?(job.bidding_closes_on)
  end
end
