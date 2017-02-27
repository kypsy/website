class Label < ActiveRecord::Base
  validates :name, presence: true

  class << self
    def options_for_select
      all.map{ |d| [d.name.capitalize, d.id] }
    end
  end

end
