class MyLabel < ActiveRecord::Base
  belongs_to :user
  belongs_to :label
  validates  :user,  presence: true
  validates  :label, presence: true
end
