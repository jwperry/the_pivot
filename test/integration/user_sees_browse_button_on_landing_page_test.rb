require "test_helper"

class UserSeesBrowseButtonOnLandingPageTest < ActionDispatch::IntegrationTest
  test "user can visit landing page and see browse buttons" do
    visit "/"

    assert page.has_css?("h1", text: "Freelancer")
    assert page.has_link?("Browse by Poster", href: artists_path)
    assert page.has_link?("Browse by Category", href: categories_path)
    assert page.has_link?("Create Account", href: sign_up_path)
    assert page.has_link?("Log In", href: login_path)
  end
end
