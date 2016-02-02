require "test_helper"

class UserCanCreateAccountTest < ActionDispatch::IntegrationTest
  test "user can create account and sees profile" do
    visit "/"

    first(:link, "Create Account").click
    assert_equal sign_up_path, current_path

    fill_in "First name", with: "Brenna"
    fill_in "Last name", with: "Martenson"
    fill_in "Email address", with: "brenna@awesome.com"
    fill_in "Street address", with: "123 Maple Drive"
    fill_in "City", with: "Denver"
    select('Colorado', from: 'user_state')
    fill_in "Zipcode", with: "80231"
    fill_in "Username", with: "brenna"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_on "Create User"
    user = User.last
    assert_equal "/dashboard", current_path
    within(".nav-wrapper") do
      assert page.has_content?("My Dashboard (contractor)")
    end
  end
end
