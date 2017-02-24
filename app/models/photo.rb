class Photo < ActiveRecord::Base
  attr_accessor :manipulate
  belongs_to :user, counter_cache: true
  has_many :red_flags, as: :flaggable, dependent: :destroy
  mount_uploader :image, ImageUploader
  validates :image, presence: true
  before_create :clean_url
  before_save :check_avatar
  before_save :process_manipulation, if: :manipulate
  after_save  :recreate_versions!, if: :manipulate
  scope :today, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }

  private

  def recreate_versions!
    self.image.recreate_versions!
  end

  def process_manipulation
    return unless self.manipulate.respond_to? :has_key?
    self.image.rotate(self.manipulate)
  end

  def clean_url
    self.remote_image_url.gsub!("+", "%20") if self.remote_image_url
  end

  def check_avatar
    avatars = self.user.photos.where(avatar: true)
    avatars.to_a.delete(self)
    if avatars.empty?
      self.avatar = true
    elsif avatar
      avatars.each { |avatar| avatar.update_attributes(avatar: false)}
    end
  end
end
