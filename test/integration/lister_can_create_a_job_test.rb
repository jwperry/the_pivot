require 'test_helper'

class ListerCanCreateAJobTest < ActionDispatch::IntegrationTest
  test "lister can create a new job" do
    lister = create(:lister)
    category = create(:category)
    assert_equal [], lister.jobs
    visit login_path

    fill_in "Username", with: lister.username
    fill_in "Password", with: lister.password
    within ".profile-form" do
      click_on "Login"
    end

    assert_equal dashboard_path, current_path
    click_on "Create Job"
    assert_equal new_user_job_path(lister), current_path
    fill_in "Title", with: "new_title"
    select category.name, from: "Category"
    fill_in "Description", with: "Test Description"
    fill_in "City", with: "Rome"
    select "Nevada", from: "job_state"
    fill_in "Zipcode", with: 77_777
    fill_in "job[must_complete_by_date]", with: "02/15/2016"
    fill_in "job[bidding_close_date]", with: "02/10/2016"
    select "05 PM", from: "bid_close_time_4i"
    select "30", from: "bid_close_time_5i"
    fill_in "Duration estimate", with: 2
    click_on "Create Job"
  end
end
