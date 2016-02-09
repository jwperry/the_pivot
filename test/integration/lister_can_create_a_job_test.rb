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
    fill_in "job[bidding_close_date]", with: "2022-02-10"
    fill_in "job[must_complete_by_date]", with: "2022-02-15"
    select "05 PM", from: "bid_close_time_4i"
    select "30", from: "bid_close_time_5i"
    select "Long", from: "job[duration_estimate]"
    click_on "Create Job"

    job = Job.last
    assert_equal user_job_path(lister, job), current_path
    assert page.has_content?(job.title)
    assert page.has_content?(job.category.name)
    assert page.has_content?(job.description)
    assert page.has_content?(job.city)
    assert page.has_content?(job.state)
    save_and_open_page
    assert page.has_content?(job.bidding_closes_on)
    assert page.has_content?(job.complete_by_date)
    assert page.has_content?(job.duration_estimate)
  end

  test "contractor cannot create new job" do
    contractor = create(:contractor)
    category = create(:category)
    assert_equal [], contractor.jobs
    visit login_path

    fill_in "Username", with: contractor.username
    fill_in "Password", with: contractor.password
    within ".profile-form" do
      click_on "Login"
    end

    visit new_user_job_path(contractor)
    assert_equal new_user_job_path(contractor), current_path
    fill_in "Title", with: "new_title"
    select category.name, from: "Category"
    fill_in "Description", with: "Test Description"
    fill_in "City", with: "Rome"
    select "Nevada", from: "job_state"
    fill_in "Zipcode", with: 77_777
    fill_in "job[bidding_close_date]", with: "2016-02-10"
    fill_in "job[must_complete_by_date]", with: "2016-02-15"
    select "05 PM", from: "bid_close_time_4i"
    select "30", from: "bid_close_time_5i"
    select "Long", from: "job[duration_estimate]"
    click_on "Create Job"

    assert_equal [], contractor.jobs
    assert_equal dashboard_path(contractor), current_path
    assert page.has_content?("Upgrade to a lister account to create jobs.")
  end
end
