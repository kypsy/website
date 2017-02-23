class CreateYourLabels < ActiveRecord::Migration
  def self.up
    create_table :your_labels do |t|
      t.integer :user_id
      t.integer :label_id

      t.timestamps
    end
  end

  def self.down
    drop_table :your_labels
  end
end
