require "test_helper"

class UserViewsPublicUserProfilesTest < ActionDispatch::IntegrationTest
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
    create(:bid, status: "accepted", job_id: job.id)

    visit login_path

    fill_in "Username", with: contractor.username
    fill_in "Password", with: contractor.password
    within "form" do
      click_button "Login"
    end

    assert_equal dashboard_path, current_path

    click_on "Public Profile"

    assert_equal user_path(contractor), current_path

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

  test "logged in contract can view a job lister profile" do
    contractor = create(:contractor)
    lister = create(:lister)
    comment_for_lister = create(:comment,
                                user_id: contractor.id,
                                recipient_id: lister.id)
    listers_posted_job = comment_for_lister.job
    listers_posted_job.update_attribute(:user_id, lister.id)
    create(:bid, status: "accepted", job_id: listers_posted_job.id)

    comment_as_contractor = create(:comment,
                                   user_id: contractor.id,
                                   recipient_id: lister.id)
    job_performed = comment_as_contractor.job
    create(:bid, status: "accepted", job_id: job_performed.id)

    visit login_path

    fill_in "Username", with: contractor.username
    fill_in "Password", with: contractor.password
    within "form" do
      click_button "Login"
    end

    visit user_job_path(lister, listers_posted_job)

    click_on lister.full_name

    assert_equal user_path(lister), current_path

    assert page.has_css? "h2", text: lister.full_name
    assert page.has_link? lister.email_address
    assert page.has_css? "h5", text: lister.location
    assert page.has_css? "h5", text: lister.rating
    assert page.has_css? "p", text: lister.bio
    assert page.has_css? "h3", text: "Comments"

    assert page.has_content? "Previous Jobs"
    within "#previous-jobs" do
      assert page.has_link? comment_as_contractor.associated_job_title,
                            user_job_path(lister, comment_as_contractor.job)
      assert page.has_content? comment_as_contractor.associated_job_duration
      assert page.has_css? "p", comment_as_contractor.text
      assert page.has_css? "p", comment_as_contractor.accepted_bid_price
      assert page.has_css? "p", "#{comment_as_contractor.rating} / 5.0"
      assert page.has_link? comment_as_contractor.user.full_name,
                            user_path(lister, comment_as_contractor.job)
      assert page.has_css? "p", comment_as_contractor.posted_at
    end

    assert page.has_content? "Previous Listings"
    within "#previous-listings" do
      assert page.has_link? comment_for_lister.associated_job_title,
                            user_job_path(lister, comment_for_lister.job)
      assert page.has_content? comment_for_lister.associated_job_duration
      assert page.has_css? "p", comment_for_lister.text
      assert page.has_css? "p", comment_for_lister.accepted_bid_price
      assert page.has_css? "p", "#{comment_for_lister.rating} / 5.0"
      assert page.has_link? comment_for_lister.user.full_name,
                            user_path(lister, comment_for_lister.job)
      assert page.has_css? "p", comment_for_lister.posted_at
    end
  end

  test "logged in lister can view their own public profile" do
    contractor = create(:contractor)
    lister = create(:lister)
    comment_for_lister = create(:comment,
                                user_id: contractor.id,
                                recipient_id: lister.id)
    listers_posted_job = comment_for_lister.job
    listers_posted_job.update_attribute(:user_id, lister.id)
    create(:bid, status: "accepted", job_id: listers_posted_job.id)

    comment_as_contractor = create(:comment,
                                   user_id: contractor.id,
                                   recipient_id: lister.id)
    job_performed = comment_as_contractor.job
    create(:bid, status: "accepted", job_id: job_performed.id)

    visit login_path

    fill_in "Username", with: lister.username
    fill_in "Password", with: lister.password
    within "form" do
      click_button "Login"
    end

    assert_equal dashboard_path, current_path

    click_on "Public Profile"

    assert_equal user_path(lister), current_path

    assert page.has_css? "h2", text: lister.full_name
    assert page.has_link? lister.email_address
    assert page.has_css? "h5", text: lister.location
    assert page.has_css? "h5", text: lister.rating
    assert page.has_css? "p", text: lister.bio
    assert page.has_css? "h3", text: "Comments"

    assert page.has_content? "Previous Jobs"
    within "#previous-jobs" do
      assert page.has_link? comment_as_contractor.associated_job_title,
                            user_job_path(lister, comment_as_contractor.job)
      assert page.has_content? comment_as_contractor.associated_job_duration
      assert page.has_css? "p", comment_as_contractor.text
      assert page.has_css? "p", comment_as_contractor.accepted_bid_price
      assert page.has_css? "p", "#{comment_as_contractor.rating} / 5.0"
      assert page.has_link? comment_as_contractor.user.full_name,
                            user_path(lister, comment_as_contractor.job)
      assert page.has_css? "p", comment_as_contractor.posted_at
    end

    assert page.has_content? "Previous Listings"
    within "#previous-listings" do
      assert page.has_link? comment_for_lister.associated_job_title,
                            user_job_path(lister, comment_for_lister.job)
      assert page.has_content? comment_for_lister.associated_job_duration
      assert page.has_css? "p", comment_for_lister.text
      assert page.has_css? "p", comment_for_lister.accepted_bid_price
      assert page.has_css? "p", "#{comment_for_lister.rating} / 5.0"
      assert page.has_link? comment_for_lister.user.full_name,
                            user_path(lister, comment_for_lister.job)
      assert page.has_css? "p", comment_for_lister.posted_at
    end
  end
end
