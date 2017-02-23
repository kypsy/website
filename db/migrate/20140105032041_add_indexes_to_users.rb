class AddIndexesToUsers < ActiveRecord::Migration
  def up
    execute "create extension unaccent"
    add_index :users, :state_id
  end
  
  def down
    execute "drop extension unaccent"
    remove_index :users, :state_id
  end
end
