class Interest < ApplicationRecord
  has_many :user_interests
  has_many :users, through: :user_interests

  validates :name, presence: true, uniqueness: true

  include Slug
end
