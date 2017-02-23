class CreateCrushes < ActiveRecord::Migration
  def self.up
    create_table :crushes do |t|
      t.integer :crusher_id
      t.integer :crushee_id
      t.boolean :secret, default: false

      t.timestamps
    end
  end

  def self.down
    drop_table :crushes
  end
end
