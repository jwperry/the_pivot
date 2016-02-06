require "test_helper"

class GuestCanCreateAnAccountTest < ActionDispatch::IntegrationTest
  test "guest creates contractor account" do
    visit new_user_path

    fill_in "First name", with: "Toni"
    fill_in "Last name", with: "Rib"
    fill_in "Email address", with: "toni@awesome.com"
    fill_in "Street address", with: "123 Maple Drive"
    fill_in "City", with: "Denver"
    select "Colorado", from: "user_state"
    fill_in "Zipcode", with: "80231"
    fill_in "Username", with: "toni_artist"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    select "contractor", from: "user_role"
    click_on "Create User"

    user = User.last
    assert_equal "contractor", user.role

    assert_equal dashboard_path, current_path
  end
  test "guest creates lister account" do
    visit new_user_path

    fill_in "First name", with: "Toni"
    fill_in "Last name", with: "Rib"
    fill_in "Email address", with: "toni@awesome.com"
    fill_in "Street address", with: "123 Maple Drive"
    fill_in "City", with: "Denver"
    select "Colorado", from: "user_state"
    fill_in "Zipcode", with: "80231"
    fill_in "Username", with: "toni_artist"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    select "lister", from: "user_role"
    click_on "Create User"

    user = User.last
    assert_equal "lister", user.role

    assert_equal dashboard_path, current_path
  end
end
