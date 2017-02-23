unless Rails.env.test?
  ActionMailer::Base.smtp_settings = {
    :port =>           '25',
    :address =>        'email-smtp.us-west-2.amazonaws.com',
    :user_name =>      ENV['SMTP_USERNAME'],
    :password =>       ENV['SMTP_PASSWORD'],
    :domain =>         'kypsy.com',
    :authentication => :plain
  }
  ActionMailer::Base.delivery_method = :smtp
end
