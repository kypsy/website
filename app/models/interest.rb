class Interest < ApplicationRecord
  include Slug

  validates :name, presence: true, uniqueness: true

  default_scope { order "slug asc" }

  # has_many :user_interests
  # has_many :users, through: :user_interests
end
