ENV["RAILS_ENV"] ||= "test"
require "simplecov"
SimpleCov.start "rails"
puts "required simplecov"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "capybara/rails"
require "database_cleaner"
require "mocha/mini_test"

DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  fixtures :all
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
    reset_session!
  end
end

class ActiveRecord::Base
  @@shared_connection = retrieve_connection
  def self.connection
    @@shared_connection || retrieve_connection
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  def i_need_javascript
    initial_driver = Capybara.current_driver
    Capybara.current_driver = Capybara.javascript_driver
    yield
  ensure
    Capybara.current_driver = initial_driver
  end

  def verify_job_info(job)
    within "#job-info" do
      assert page.has_content? job.title
      assert page.has_content? job.description
      assert page.has_content? job.duration_estimate
      bid_range = "Bid Range: $#{job.lowest_bid} - $#{job.highest_bid}"
      assert page.has_content? bid_range

      if job.total_bids == 1
        assert page.has_content? "#{job.total_bids} bid"
      else
        assert page.has_content? "#{job.total_bids} bids"
      end

      assert page.has_content? "Must Be Completed By: #{job.complete_by_date}"
      assert page.has_content? "Bidding Ends: #{job.bidding_closes_on}"
      assert page.has_content? job.location
      assert page.has_css? "#google-map"
    end
  end

  def verify_lister_info(lister)
    within "#lister-info" do
      assert page.has_link? lister.full_name, user_path(lister)
      assert page.has_content? lister.rating
      assert page.has_css?("img[src*='#{lister.file_upload_file_name}']")

      if lister.number_of_active_jobs == 1
        assert page.has_content? "1 Active Job"
      else
        assert page.has_content? "#{lister.number_of_active_jobs} Active Jobs"
      end

      if lister.number_of_completed_jobs == 1
        assert page.has_content? "1 Completed Job"
      else
        num_complete_jobs = "#{lister.number_of_completed_jobs} Completed Jobs"
        assert page.has_content? num_complete_jobs
      end

      assert page.has_content? "Active Since #{lister.account_created_date}"
    end
  end
end
