class Bookmark < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :bookmarkee, class_name: "User", touch: true
  
  validates :bookmarkee_id, :user_id, presence: true
  scope :today, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }
end
