Sidekiq.configure_server do |config|
  config.periodic do |mgr|
    # see any crontab reference for the first argument
    # e.g. http://www.adminschoice.com/crontab-quick-reference
    mgr.register('1 * * * *', BiddingWorker, retry: 2)
  end
end
