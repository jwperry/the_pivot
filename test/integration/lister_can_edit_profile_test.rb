require "test_helper"

class ListerCanEditProfileTest < ActionDispatch::IntegrationTest
  test "lister can edit profile" do
    lister = create(:lister)
    original_lister = lister.dup
    visit root_path
    
    within("#nav-mobile") do
      click_on "Login"
    end
    fill_in "Username", with: lister.username
    fill_in "Password", with: lister.password
    within(".profile-form") do
      click_on "Login"
    end

    assert_equal dashboard_path, current_path
    assert page.has_content?(lister.first_name)
    assert page.has_content?(lister.last_name)
    assert page.has_content?(lister.email_address)
    assert page.has_content?(lister.street_address)
    assert page.has_content?(lister.city)
    assert page.has_content?(lister.state)
    assert page.has_content?(lister.zipcode)
    assert page.has_content?(lister.bio)
    click_on "Edit Profile"

    assert edit_user_path(lister), current_path
    fill_in "First name", with: "new_first_name"
    fill_in "Last name", with: "new_last_name"
    fill_in "Email address", with: "new_email_address@example.com"
    fill_in "Street address", with: "new_street_address"
    fill_in "City", with: "new_city"
    select "Washington", from: "user_state"
    fill_in "Zipcode", with: 22222
    fill_in "Bio", with: "new_bio"
    fill_in "Password", with: "new_password"
    fill_in "Password confirmation", with: "new_password"
    click_on "Update User"

    lister.reload
    assert_equal dashboard_path, current_path
    assert page.has_content?(lister.first_name)
    assert page.has_content?(lister.last_name)
    assert page.has_content?(lister.email_address)
    assert page.has_content?(lister.street_address)
    assert page.has_content?(lister.city)
    assert page.has_content?(lister.state)
    assert page.has_content?(lister.zipcode)
    assert page.has_content?(lister.bio)
    refute page.has_content?(original_lister.first_name)
    refute page.has_content?(original_lister.last_name)
    refute page.has_content?(original_lister.email_address)
    refute page.has_content?(original_lister.street_address)
    refute page.has_content?(original_lister.city)
    refute page.has_content?(original_lister.state)
    refute page.has_content?(original_lister.zipcode)
    refute page.has_content?(original_lister.bio)
  end

  test "only contractors editing their profile see the role dropdown" do
    skip
  end

  def fixture_image_path
    Rails.root.join("test", "helpers", "test_image.jpg")
  end
end
