class State < ActiveRecord::Base
  has_many :users

  class << self
    def options_for_select
      State.order(:name).map{ |s| [s.name.capitalize, s.id] }
    end
  end
  
  def to_s
    abbreviation.upcase
  end
end
