class YourLabel < ActiveRecord::Base
  belongs_to :user
  belongs_to :label, polymorphic: true
  validates  :user,  presence: true
  validates  :label, presence: true
  validates  :label_id, uniqueness: { scope: [:user_id, :label_type] }
  
  def self.label_assignments
    select(:id, :label_id, :label_type).reduce({}) do |result, label| 
      result[label.label_type] ||= {}
      result[label.label_type][label.label_id] = label.id
      result
    end
  end
end
