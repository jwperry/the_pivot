require "test_helper"

class UserViewsJobShowPageTest < ActionDispatch::IntegrationTest
  test "guest views job show page" do
    job = create(:job)

    visit user_job_path(job.lister, job)

    refute page.has_css? "#accordion h3", text: "Place A Bid"
    assert page.has_link? "Log In To Place A Bid", login_path

    
  end
end

# And I do see info for the job:
#
# A link back to the category show
# The name of the job
# The full description of the job
# Poster's name as link to profile
# Poster's image
# Estimated duration tag
# "Must be completed by" date
# "Bidding ends" date
# Location of the job
# Super awesome GoogleMap showing location by zipcode
# Lister's Information showing:
# Name
# Rating
# Picture
# Number of active jobs
# Number of completed jobs
# "Active Since" date
