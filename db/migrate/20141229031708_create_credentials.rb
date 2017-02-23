class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.boolean :expires, default: false
      t.datetime :expires_at
      t.integer :user_id
      t.string :provider_name
      t.text :token

      t.timestamps
    end
  end
end
