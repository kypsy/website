class CreateLatLngs < ActiveRecord::Migration
  def change
    create_table :lat_lngs do |t|
      t.decimal :lat, precision: 8, scale: 5
      t.decimal :lng, precision: 8, scale: 5
      t.string :username, :location
      t.text :avatar
      t.belongs_to :user

      t.timestamps
    end
  end
end
