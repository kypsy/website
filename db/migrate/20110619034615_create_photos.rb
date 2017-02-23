class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :image
      t.boolean :avatar
      t.text :caption
      t.belongs_to :user

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
