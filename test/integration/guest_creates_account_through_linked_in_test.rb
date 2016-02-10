require "test_helper"

class GuestCreatesAccountThroughLinkedInTest < ActionDispatch::IntegrationTest
  test "guest creates account through linked in" do
    User::UsersController.any_instance.stubs(:auth_hash).returns(sample_auth_hash)

    visit linkedin_path

    linked_in_bio = "Senior Developer, Hammertech\nIndustry: Internet\nLinkedIn Profile: http://www.linkedin.com/in/johndoe"

    assert page.has_content?("Create a New Account")
    assert_equal "John", find("#user_first_name").value
    assert_equal "Doe", find("#user_last_name").value
    assert_equal "john@doe.com", find("#user_email_address").value
    assert_equal "Greater Boston Area", find("#user_city").value
    assert_equal linked_in_bio, find("#user_bio").value
    assert_equal "http://www.linkedin.com/in/johndoe", find("#user_image_path").value
  end

  test "guest logs in through linked in" do
    User::UsersController.any_instance.stubs(:auth_hash).returns(sample_auth_hash)
    contractor = create(:contractor)
    contractor.authorizations.create provider: sample_auth_hash["provider"], uid: sample_auth_hash["uid"]
    visit linkedin_path

    assert_equal dashboard_path, current_path

    within(".user-dashboard-info") do
      assert page.has_css?("img[src*='#{contractor.file_upload_file_name}']")
      assert page.has_content?(contractor.first_name)
      assert page.has_content?(contractor.last_name)
      assert page.has_link?(contractor.email_address)
      assert page.has_content?(contractor.street_address)
      assert page.has_content?(contractor.city)
      assert page.has_content?(contractor.state)
      assert page.has_content?(contractor.zipcode)
      assert page.has_content?(contractor.bio)
    end
  end

  def sample_auth_hash
    sample_auth_hash = {
  "provider"=>"linkedin",
  "uid"=>"AbC123",
  "info"=> {
    "name"=>"John Doe",
    "email"=>"john@doe.com",
    "nickname"=>"John Doe",
    "first_name"=>"John",
    "last_name"=>"Doe",
    "location"=>"Greater Boston Area, US",
    "description"=>"Senior Developer, Hammertech",
    "image"=> "http://m.c.lnkd.licdn.com/mpr/mprx/0_aBcD...",
    "phone"=>"null",
    "headline"=> "Senior Developer, Hammertech",
    "industry"=>"Internet",
    "urls"=>{
      "public_profile"=>"http://www.linkedin.com/in/johndoe"
    }
  },
  "credentials"=> {
    "token"=>"12312...",
    "secret"=>"aBc..."
  },
  "extra"=>
  {
    "access_token"=> {
      "token"=>"12312...",
      "secret"=>"aBc...",
      "consumer"=>nil, #<OAuth::Consumer>
      "params"=> {
        :oauth_token=>"12312...",
        :oauth_token_secret=>"aBc...",
        :oauth_expires_in=>"5183999",
        :oauth_authorization_expires_in=>"5183999",
      },
      "response"=>nil #<Net::HTTPResponse>
    },
   "raw_info"=> {
     "firstName"=>"Joe",
     "headline"=>"Senior Developer, Hammertech",
     "id"=>"AbC123",
     "industry"=>"Internet",
     "lastName"=>"Doe",
     "location"=> {"country"=>{"code"=>"us"}, "name"=>"Greater Boston Area"},
     "pictureUrl"=> "http://m.c.lnkd.licdn.com/mpr/mprx/0_aBcD...",
     "publicProfileUrl"=>"http://www.linkedin.com/in/johndoe"
    }
  }
}
end
end
