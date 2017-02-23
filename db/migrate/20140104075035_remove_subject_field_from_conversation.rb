class RemoveSubjectFieldFromConversation < ActiveRecord::Migration
  def up
    remove_column :conversations, :subject
  end
  
  def down
    add_column :conversations, :subject, :text
  end
end