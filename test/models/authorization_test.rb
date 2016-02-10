require "test_helper"

class AuthorizationTest < ActiveSupport::TestCase
  should belong_to(:user)
end
