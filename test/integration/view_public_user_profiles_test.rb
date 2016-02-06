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

  test "logged in contractor can view profile" do
    contractor = create(:contractor)
    
  end
end
