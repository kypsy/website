FactoryGirl.define do

  factory :red_flag do
    flaggable_type "User"
    flaggable { create(:user) }
    reporter { create(:user) }
  end

  factory :provider do
    name "default"
    uid "1234"
    factory :twitter do
      name "twitter"
    end
  end

  factory :photo do
    image Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/support/small.png')))
    user
  end

  factory :user do
    name "User T. Duncan"
    sequence :username do |n| "User#{n}" end
    email              "test@example.com"
    birthday           { 22.years.ago }
    agreed_to_terms_at { Time.now }
    visible true

    factory :shane do
      name     "Shane Becker"
      username "veganstraightedge"
      birthday { 32.years.ago }
    end

    factory :bookis do
      name     "Bookis Smuin"
      username "Bookis"
      birthday { 27.years.ago }
    end
  end

  factory :block do
    user
    association :blocked_user, factory: :bookis
  end

  factory :label do
    name "sXe"
  end

  factory :credential do
    user
    token "1234"
    provider_name "twitter"
  end

  factory :message do
    association :recipient, factory: :user, username: "R-E-Cipient", email: "r@example.com"
    association :sender, factory: :user, username: "Sen-Der"
  end

  factory :crush do
    association :crushee, factory: :user, username: "R-E-Cipient", email: "r@example.com"
    association :crusher, factory: :user, username: "Sen-Der"
  end
end
