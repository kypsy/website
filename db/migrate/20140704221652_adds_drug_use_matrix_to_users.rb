class AddsDrugUseMatrixToUsers < ActiveRecord::Migration
  def change
    add_column :users, :drug_use, :hstore, default: {
      alcohol: "never",
      cigarettes: "never",
      marijuana: "never",
      drugs: "never"
    }
  end
end
