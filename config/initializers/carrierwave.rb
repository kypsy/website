if Rails.env.test? || Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  if ENV["KYPSY_AWS_ACCESS_KEY"]
    CarrierWave.configure do |config|
      config.storage =  :aws
      config.aws_credentials = {
        access_key_id:     ENV["KYPSY_AWS_ACCESS_KEY"],
        secret_access_key: ENV["KYPSY_AWS_SECRET_KEY"],
        region:            ENV["KYPSY_AWS_REGION"]
      }
      config.aws_bucket  = ENV["FOG_DIRECTORY"]
      config.asset_host     = "https://#{ENV["FOG_DIRECTORY"]}.s3.amazonaws.com"
    end
  end
end
