class AddTypeToYourLabels < ActiveRecord::Migration
  def change
    add_column :your_labels, :label_type, :string, default: "Label"
    YourLabel.update_all(label_type: "Label")
  end
end
