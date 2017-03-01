class CreateUserInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :user_interests do |t|
      t.integer :user_id
      t.integer :interest_id

      t.timestamps
    end
  end
end
