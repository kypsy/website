class NotificationJob
  # extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :notification

  def self.perform(notification_type, *args)
    Notification.send(notification_type, *args).deliver
  end

end
