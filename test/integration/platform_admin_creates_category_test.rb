require "test_helper"

class PlatformAdminCreatesCategoryTest < ActionDispatch::IntegrationTest
  test "platform admin creates category" do
    admin = create(:platform_admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit dashboard_path
    click_on "Create Category"
    description = "Discover the meaning of the universe"

    fill_in "Name", with: "Astrophysics"
    fill_in "Description", with: description
    click_on "Create Category"

    category = Category.last

    assert_equal category_path(category), current_path

    assert page.has_content?("Astrophysics")
    assert_equal description, category.description
  end
end
