class AddHandleToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :handle, :string
    add_column :providers, :last_login_at, :datetime
    add_column :providers, :ip_address, :string
  end
end
