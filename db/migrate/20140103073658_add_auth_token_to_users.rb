class AddAuthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string
    User.all.each {|user| user.send(:generate_auth_token); user.save }
  end
end
