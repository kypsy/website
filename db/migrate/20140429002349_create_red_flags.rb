class CreateRedFlags < ActiveRecord::Migration
  def up
    create_table :red_flags do |t|
      t.integer :flaggable_id
      t.string  :flaggable_type, :slug
      t.integer :reporter_id

      t.timestamps
    end
    add_index :red_flags, :slug
  end
  
  def down
    drop_table :red_flags
  end
end
