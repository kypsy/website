class Crush < ActiveRecord::Base
  belongs_to :crusher, class_name: "User", touch: true
  belongs_to :crushee, class_name: "User", touch: true

  scope :today, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }

  def notify
    Resque.enqueue(NotificationJob, :new_crush, self.id)
  end

  def needs_notify?
    crushee.email_crushes?
  end

end
