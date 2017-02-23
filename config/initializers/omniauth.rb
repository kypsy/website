Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,  ENV["KYPSY_TWITTER_CONSUMER_KEY"],  ENV["KYPSY_TWITTER_CONSUMER_SECRET"]
  provider :facebook, ENV["KYPSY_FACEBOOK_CONSUMER_KEY"], ENV["KYPSY_FACEBOOK_CONSUMER_SECRET"]
end
