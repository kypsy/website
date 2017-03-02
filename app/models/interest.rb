class Interest < ApplicationRecord
  include Slug

  validates :name, presence: true, uniqueness: true

  # has_many :user_interests
  # has_many :users, through: :user_interests
end
