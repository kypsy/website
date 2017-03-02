  # This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/poltergeist'
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

OmniAuth.config.test_mode = true
RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  DatabaseCleaner.strategy = :truncation
  Capybara.javascript_driver = :poltergeist
  config.include FactoryGirl::Syntax::Methods
  config.after(:each) do
    if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads"])
    end
  end
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    allow(Resque).to receive(:enqueue).and_return(true)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

OmniAuth.config.mock_auth[:twitter]  = OmniAuth::AuthHash.new(twitter_auth_response)
OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(facebook_auth_response)

def sign_in(user=nil)
  user ||= User.create(username: "Shane", name: "SB", email: "test@example.com", agreed_to_terms_at: Time.now, visible: true)
  cookies.signed[:auth_token] = user.auth_token
end
