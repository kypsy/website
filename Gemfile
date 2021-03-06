source "https://rubygems.org"
ruby "2.4.1"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 5.1.0"
gem "puma"
gem "coffee-rails"
gem "email_address_validator", "0.0.3",   github: "bookis/email_address_validator"
gem "indefinite_article"
gem "jquery-rails"
gem "json"
gem "pg"

# for respond_to, remove once json responses are moved to the API
gem "responders"
gem "redcarpet" # Markdown parser
gem "rollbar"
gem "sass-rails"
gem "uglifier"
gem "will_paginate"
gem "will_paginate-bootstrap"
gem "bootstrap", "~> 4.0.0.alpha6"
gem "font-awesome-rails"

gem "kramdown"  # for Markdown processing
gem "rubypants" # for smart quotes
gem "sterile"   # for slugs

# bootstrap tooltips and popovers depend on tether for positioning
source "https://rails-assets.org" do
  gem "rails-assets-tether", ">= 1.1.0"
end

# caching
gem "memcachier"
gem "dalli"
gem "kgio"

# background
gem "resque"#, require: "resque/server"
# gem "heroku_resque_autoscaler", github: "bookis/heroku_resque_autoscaler"

# search
gem "pg_search"

# image uploads
gem "rmagick", require: false
gem "carrierwave-aws"

# auth
gem "omniauth-twitter"
gem "omniauth-facebook"

# facebook api / rest
gem "koala"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "dotenv-rails"
  gem "foreman"
  gem "guard-rspec"
  gem "gx"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "web-console"
end

group :development, :test do
  gem "byebug", platform: :mri

  gem "rails-controller-testing"
  gem "capybara"
  gem "factory_girl_rails"
  gem "poltergeist"
  gem "terminal-notifier-guard"

  gem "rspec-rails"
  gem "rspec-activemodel-mocks"
end

group :test do
  gem "rspec"
  gem "database_cleaner"
end

group :production, :staging do
  gem "newrelic_rpm"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
