require "test_helper"

class PlatformAdminCreatesCategoryTest < ActionDispatch::IntegrationTest
  test "platform admin creates category" do
    admin = create(:platform_admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit dashboard_path
    click_on "Create Category"

    fill_in "Name", with: "Astrophysics"
    click_on "Create Category"

    category = Category.last

    assert_equal category_path(category), current_path
    assert page.has_content?("Astrophysics")
  end

  test "non-platform admin cannot create a category" do
    contractor = create(:contractor)
    ApplicationController.any_instance.stubs(:current_user).returns(contractor)

    visit new_category_path
    assert page.has_content?("The page you were looking for doesn't exist.")
    refute page.has_content?("Create a New Category")
  end
end
