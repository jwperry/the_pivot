require "test_helper"

class ViewPublicUserProfilesTest < ActionDispatch::IntegrationTest
  test "guest is redirected to login page from category show" do
    job = create(:job)
    category = job.category

    visit category_path(category)

    click_on job.lister.full_name

    assert_equal login_path, current_path
  end

  test "guest is redirected to login page if trying to visit user show" do
    lister = create(:lister)

    visit user_path(lister)

    assert_equal login_path, current_path
  end

  test "logged in contractor can view their public profile" do
    contractor = create(:contractor)
    lister = create(:lister)
    comment = create(:comment, user_id: lister.id, recipient_id: contractor.id)
    job = comment.job
    bid = create(:bid, status: "accepted", job_id: job.id)

    visit login_path

    fill_in "Username", with: contractor.username
    fill_in "Password", with: contractor.password
    within "form" do
      click_button "Login"
    end

    # When I visit "/dashboard",
    # And I click "Public Profile",
    visit user_path(contractor)

    assert page.has_css? "h2", text: contractor.full_name
    assert page.has_link? contractor.email_address
    assert page.has_css? "h5", text: contractor.location
    assert page.has_css? "h5", text: contractor.rating
    assert page.has_css? "p", text: contractor.bio
    assert page.has_css? "h3", text: "Comments"

    assert page.has_content? "Previous Jobs"
    within "#previous-jobs" do
      assert page.has_link? comment.associated_job_title,
                            user_job_path(lister, comment.job)
      assert page.has_content? comment.associated_job_duration
      assert page.has_css? "p", comment.text
      assert page.has_css? "p", comment.accepted_bid_price
      assert page.has_css? "p", "#{comment.rating} / 5.0"
      assert page.has_link? comment.user.full_name,
                            user_path(lister, comment.job)
      assert page.has_css? "p", comment.posted_at
    end
  end
end
