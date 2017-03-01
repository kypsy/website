class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.date   :birthday

      t.string :name
      t.string :username
      t.string :email
      t.string :city
      t.string :zipcode

      t.integer :age_range_id

      t.boolean :visible, default: false

      t.text   :bio

      t.belongs_to :label
      t.belongs_to :diet

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
