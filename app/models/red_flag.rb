class RedFlag < ActiveRecord::Base
  belongs_to :flaggable, polymorphic: true
  belongs_to :reporter, class_name: "User"
  validates :flaggable_id, :reporter_id, :slug, presence: true
  validates :flaggable_id, uniqueness: {scope: [:reporter_id, :flaggable_type]}
  before_validation :set_slug, on: :create
  scope :today, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }
  
  def set_slug
    self.slug = "#{flaggable_type.downcase}-#{flaggable_id}"
  end
end
