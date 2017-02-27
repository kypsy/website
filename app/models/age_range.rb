class AgeRange < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true


  class << self
    def options_for_select
      all.map{ |d| [d.name.capitalize, d.id] }
    end
  end

end
