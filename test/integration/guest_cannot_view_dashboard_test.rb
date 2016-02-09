require "test_helper"

class GuestCannotViewDashboardTest < ActionDispatch::IntegrationTest
  test "guest cannot view dashboard" do
    visit dashboard_path

    assert_equal login_path, current_path
  end
end
