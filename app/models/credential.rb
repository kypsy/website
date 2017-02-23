class Credential < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :token, :provider_name, presence: true
end
