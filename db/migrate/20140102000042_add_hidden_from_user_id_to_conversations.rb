class AddHiddenFromUserIdToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :hidden_from_user_id, :integer
  end
end
