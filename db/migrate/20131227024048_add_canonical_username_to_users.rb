class AddCanonicalUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :canonical_username, :string
    User.all.each {|user| user.send(:create_canonical_username); user.save }
  end
end
