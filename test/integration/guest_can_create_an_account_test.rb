require "test_helper"

class GuestCanCreateAnAccountTest < ActionDispatch::IntegrationTest
  test "guest creates contractor account" do
    visit new_user_path
    username = "toni_contractor"

    fill_in "First name", with: "Toni"
    fill_in "Last name", with: "Rib"
    fill_in "Email address", with: "toni@awesome.com"
    fill_in "Street address", with: "123 Maple Drive"
    fill_in "City", with: "Denver"
    select "Colorado", from: "user_state"
    fill_in "Zipcode", with: "80231"
    fill_in "Username", with: username
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    select "contractor", from: "user_role"
    fill_in "Bio", with: "In west Philadelphia born and raised"
    attach_file("user_file_upload", fixture_image_path)
    click_on "Create User"

    user = User.last
    mail_link = "mailto:#{user.email_address}"

    assert_equal "contractor", user.role
    assert_equal username, user.username

    assert_equal dashboard_path, current_path
    within(".user-dashboard-info") do
      assert page.has_css?("img[src*='#{user.file_upload_file_name}']")
      assert page.has_content?(user.first_name)
      assert page.has_content?(user.last_name)
      assert page.has_link?(user.email_address, href: mail_link)
      assert page.has_content?(user.street_address)
      assert page.has_content?(user.city)
      assert page.has_content?(user.state)
      assert page.has_content?(user.zipcode)
      assert page.has_content?(user.bio)
    end

    refute page.has_link?("Create Job")
    refute page.has_content?("My Listings")
    assert page.has_content?("My Bids")
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
    fill_in "Username", with: "toni_lister"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    select "lister", from: "user_role"
    fill_in "Bio", with: "In west Philadelphia born and raised"
    attach_file("user_file_upload", fixture_image_path)
    click_on "Create User"

    user = User.last
    mail_link = "mailto:#{user.email_address}"

    assert_equal "lister", user.role
    assert_equal dashboard_path, current_path

    within(".user-dashboard-info") do
      assert page.has_css?("img[src*='#{user.file_upload_file_name}']")
      assert page.has_content?(user.first_name)
      assert page.has_content?(user.last_name)
      assert page.has_link?(user.email_address, href: mail_link)
      assert page.has_content?(user.street_address)
      assert page.has_content?(user.city)
      assert page.has_content?(user.state)
      assert page.has_content?(user.zipcode)
      assert page.has_content?(user.bio)
    end

    assert page.has_link?("Create Job")
    assert page.has_content?("My Listings")
    assert page.has_content?("My Bids")
  end

  def fixture_image_path
    Rails.root.join("test", "helpers", "test_image.jpg")
  end
end
