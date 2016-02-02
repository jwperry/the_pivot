require "test_helper"

class GuestVisitsHomepageTest < ActionDispatch::IntegrationTest
  test "sees company name and main links" do
    visit "/"

    within first(:div, ".landing-buttons") do
      assert page.has_css?("h1", text: "Freelancer")
      assert page.has_link?("Browse by Poster", href: artists_path)
      assert page.has_link?("Browse by Category", href: categories_path)
      assert page.has_link?("Create Account", href: sign_up_path)
      assert page.has_link?("Log In", href: login_path)
    end
  end
end
