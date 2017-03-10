if Rails.env.production?
  uri = URI.parse(ENV["REDIS_URL"])
  redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  Resque.redis = redis
else
  Resque.redis = Redis.new
end
