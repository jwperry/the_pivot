desc "This task is called by the Heroku scheduler add-on"
task :update_job_status => :environment do
  puts "Updating job status..."
  Job.update_bidding_status
  puts "done."
end
