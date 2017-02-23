class ChangeMessagesSubjectToText < ActiveRecord::Migration
  def change
    change_column :conversations, :subject, :text
  end
end