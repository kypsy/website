class AddsCounterCacheToPhotos < ActiveRecord::Migration
  def up
    add_column :users, :photos_count, :integer, :default => 0
    add_index :users, :photos_count
    add_index :users, :created_at
    User.reset_column_information
    User.find_each do |user|
      User.reset_counters(user.id, :photos)
    end
  end
  
  def down
    remove_index :users, :photos_count
    remove_index :users, :created_at
    remove_column :users, :photos_count
  end
end
