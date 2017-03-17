class Activity < ApplicationRecord
  include Slug

  validates :name, presence: true, uniqueness: true

  default_scope { order "slug asc" }
end
