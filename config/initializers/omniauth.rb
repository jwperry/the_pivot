Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin,
           ENV["LINKEDIN_KEY"],
           ENV["LINKEDIN_SECRET"],
           scope: "r_basicprofile r_emailaddress",
           fields: ["id",
                    "picture-urls::(original)",
                    "email-address",
                    "first-name",
                    "last-name",
                    "headline",
                    "industry",
                    "picture-url",
                    "public-profile-url",
                    "location"]
end
