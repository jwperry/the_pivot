require "test_helper"

class ViewPublicUserProfilesTest < ActionDispatch::IntegrationTest
  test "guest is redirected to login page" do
    job = create(:job)
    category = job.category

    visit category_path(category)

    save_and_open_page

    click_on job.user.full_name
#     As a guest,
# When I visit "/categories/#{category.name}
# And I click on a poster name,
# Then I am redirected to the login path
  end

  test "logged in contractor can view profile" do

  end
end
