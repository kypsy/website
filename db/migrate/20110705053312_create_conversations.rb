class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
      t.belongs_to :user
      t.integer    :recipient_id
      t.string     :subject

      t.timestamps
    end
  end

  def self.down
    drop_table :conversations
  end
end
