class Country < ActiveRecord::Base
  has_many :users

  class << self
    def options_for_select
      countries = [
        Country.find_by(name: "United States"),
        Country.find_by(name: "Canada")
      ]
      countries << Country.order(:name)

      countries.flatten.compact.map{ |c| [c.name.capitalize, c.id] }
    end
  end
end
