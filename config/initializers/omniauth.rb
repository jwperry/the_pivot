# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET']
#   # scope: 'r_basicprofile',
#   # fields: ['id', 'first-name', 'last-name', 'location', 'picture-url', 'public-profile-url']
# end
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET']
  
end
