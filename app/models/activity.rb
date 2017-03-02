class Activity < ApplicationRecord
  include Slug

  validates :name, presence: true, uniqueness: true
end
