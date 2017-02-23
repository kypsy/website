class Message < ActiveRecord::Base
  belongs_to :conversation, touch: true
  belongs_to :sender,    class_name: "User"
  belongs_to :recipient, class_name: "User"
  validates_with AgeAppropriateValidator
  validates_with BlockValidator
  validates :recipient_id, :sender_id, presence: true
  before_save :create_conversation, unless: :conversation_id?
  after_save :unhide_conversation
  scope :unread, -> { where(unread: true)  }
  scope :read,   -> { where(unread: false) }
  scope :received, lambda { |user| where(recipient_id: user.id) }
  scope :today, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }

  def notify
    Resque.enqueue(NotificationJob, :new_message, self.id)
  end

  def needs_notify?
    recipient.email_messages?
  end

  private

  def create_conversation
    self.conversation = Conversation.create(recipient_id: self.recipient_id, user_id: self.sender_id)
  end

  def unhide_conversation
    self.conversation.unhide
  end

end
