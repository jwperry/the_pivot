require "test_helper"

class GuestVisitsHomepageTest < ActionDispatch::IntegrationTest
  test "sees company name and main links" do
    create_list(:category, 3)

    visit "/"

    within first(:div, ".landing-buttons") do
      assert page.has_css?("h1", text: "Freelancer")
      assert page.has_content?("Choose a Category")
      assert page.has_link?("Create Account", href: sign_up_path)
      assert page.has_link?("Log In", href: login_path)
    end

    category_names = Category.pluck(:name)
    category_names.unshift("Select a Category")

    within first(:div, ".category-dropdown") do
      assert page.has_select?("categories", options: category_names)
    end
  end
end
